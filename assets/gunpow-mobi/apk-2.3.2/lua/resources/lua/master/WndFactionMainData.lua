--WndFactionMainData.lua
--@brief	WndFactionMain的数据模块
--@date		2023/05/26
--@author	yrd
--@note		宗门界面

WndFactionMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFactionMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nItemId1 = 161082 			--宗门经验
	self.m_nItemId2 = 161083 			--宗门贡献
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFactionMain:_unInit()
	self.m_root = nil
	self.m_nItemId1 = nil
	self.m_nItemId2 = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFactionMain:createElement()
	if WndFactionMain.m_root ~= nil then
		WindowManager:removeWindow(WndFactionMain.m_root, WndFactionMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFactionMain")
	assert(element, "WndFactionMain create element failed!")
	self:_init()
	return element
end

--@brief	获取宗门信息OK
function WndFactionMain:getZmInfoOk(myZmLevel, myZmExp, shifuZmLevel, tudiLevel, tudiExp)
	if not self.m_root then return end

	self.m_nMyZmLevel = myZmLevel
	self.m_nMyZmExp = myZmExp
	self.m_nShifuZmLevel = shifuZmLevel
	self.m_nTudiLevel = tudiLevel
	self.m_nTudiExp = tudiExp

	self:updateUI()
end

--@brief	升级宗门等级OK
function WndFactionMain:getUpgradeZmOk(result, myZmLevel, myZmExp)
	if not self.m_root then return end

	if result == 0 then
		self.m_nMyZmLevel = myZmLevel
		self.m_nMyZmExp = myZmExp

		self:updateUI()
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO170)
	end
end

--@brief	升级宗门等级OK
function WndFactionMain:getUpgradeTudiOk(result, tudiLevel, tudiExp)
	if not self.m_root then return end

	if result == 0 then
		self.m_nTudiLevel = tudiLevel
		self.m_nTudiExp = tudiExp

		self:updateUI()
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.SEND_PROPOSAL_LETTER2)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FACTION_TEXT1[21])
	end
end

--@brief	获取宗门等级信息
function WndFactionMain:getFactionLevelInfo(level)
	for k,v in pairs(GDatatab_mentoring_zm_level) do
		if level == v.level then
			return v
		end
	end
end

--@brief	获取徒弟等级信息
function WndFactionMain:getApprenticeLevelInfo(level)
	for k,v in pairs(GDatatab_mentoring_tudi_level) do
		if level == v.level then
			return v
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
