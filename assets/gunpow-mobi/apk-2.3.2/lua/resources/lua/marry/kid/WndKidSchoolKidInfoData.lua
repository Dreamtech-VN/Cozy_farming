--WndKidSchoolKidInfoData.lua
--@brief	WndKidSchoolKidInfo的数据模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-孩子信息

WndKidSchoolKidInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolKidInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 					--小孩数据
	self.m_tChildInfo = nil 			--小孩信息数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolKidInfo:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tChildInfo = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolKidInfo:createElement()
	if WndKidSchoolKidInfo.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolKidInfo.m_root, WndKidSchoolKidInfo, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolKidInfo")
	assert(element, "WndKidSchoolKidInfo create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolKidInfo:showInterface(tData)
	local wnd = WndKidSchoolKidInfo:createElement()
	if wnd ~= nil then
		self.m_tData = tData
	    WindowManager:addWindow(wnd, WndKidSchoolKidInfo, nil, false, nil, true)
	end
end

function WndKidSchoolKidInfo:setChildInfo(learnLevel, learnExp, learnMaxExp, restLevel, restExp, restMaxExp, appreciateLevel, appreciateExp, appreciateMaxExp, learnRemainTime, scienceRemainTime, hp, maxHp, attack, maxAttack, def, maxDef)
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
	self.m_tChildInfo.hp = hp
	self.m_tChildInfo.maxHp = maxHp
	self.m_tChildInfo.attack = attack
	self.m_tChildInfo.maxAttack = maxAttack
	self.m_tChildInfo.def = def
	self.m_tChildInfo.maxDef = maxDef

	self:updateUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
