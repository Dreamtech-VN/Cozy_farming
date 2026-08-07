--WndKidSchoolSkillData.lua
--@brief	WndKidSchoolSkill的数据模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-技能

WndKidSchoolSkill = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolSkill:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tChildInfo = nil				--孩子属性
	self.m_tSkillInfo = nil 			--技能信息列表
	self.m_tCellSkill = nil 			--技能对象列表
	self.m_nCurShowSkillId = 1 			--当前显示的技能id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolSkill:_unInit()
	self.m_root = nil
	self.m_tChildInfo = nil				--孩子属性
	self.m_tUnlockSkill = nil 			--技能信息
	self.m_tCellSkill = nil
	self.m_nCurShowSkillId = nil		--当前显示的技能id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolSkill:createElement()
	if WndKidSchoolSkill.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolSkill.m_root, WndKidSchoolSkill, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolSkill")
	assert(element, "WndKidSchoolSkill create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolSkill:showInterface()
	local wnd = WndKidSchoolSkill:createElement()
	if wnd ~= nil then
	    WindowManager:addWindow(wnd, WndKidSchoolSkill, nil, false, nil, true)
	end
end

--@brief	设置数据
function WndKidSchoolSkill:setChildSkillInfo(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, useSkill, unlockSkill, unlockSkillNum)
	self.m_tChildInfo = {}
	self.m_tChildInfo.learnLevel = learnLevel
	self.m_tChildInfo.learnExp = learnExp
	self.m_tChildInfo.learnMaxExp = learnMaxExp
	self.m_tChildInfo.restLevel = restLevel
	self.m_tChildInfo.restExp = restExp
	self.m_tChildInfo.restMaxExp = restMaxExp
	self.m_tChildInfo.appreciateLevel = appreciateLevel
	self.m_tChildInfo.appreciateExp = appreciateExp
	self.m_tChildInfo.appreciateMaxExp = appreciateMaxExp
	self.m_tChildInfo.learnRemainTime = learnRemainTime
	self.m_tChildInfo.scienceRemainTime = scienceRemainTime

	self.m_tSkillInfo = {}
	for i=1,#unlockSkill do
		self.m_tSkillInfo[i] = {}
		self.m_tSkillInfo[i].id = unlockSkill[i]
		self.m_tSkillInfo[i].num = unlockSkillNum[i]
		self.m_tSkillInfo[i].isUse = false
		for j=1,#useSkill do
			if useSkill[j] == unlockSkill[i] then
				self.m_tSkillInfo[i].isUse = true
			end
		end
	end

	self:updateUI()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
