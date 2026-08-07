--WndMasterMemberData.lua
--@brief	WndMasterMember的数据模块
--@date		2015/05/27
--@author	zsq
--@note		徒弟

WndMasterMember = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterMember:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sConDepartment = nil
	self.m_sConMasterSkill = nil
	self.m_tMyPupils = {}
	self.m_bChecked = false
	self.m_tRoleAniList = nil
	self.m_tMasterElement = nil
	self.m_nMasterSkillId = 0 --师门技能
	self.m_nDiscipleSkillId = 0
	self.m_nMasterSkillStatus = 1 --技能领取状态
	self.m_tDiscipleTeachPlsyerId = {} --徒弟授业的id
	self.m_tCreateDiscipleItem = {} --创建徒弟的item
	self.m_nSceneType = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterMember:_unInit()
	self.m_root = nil
	self.m_sConDepartment = nil
	self.m_sConMasterSkill = nil
	self.m_tMyPupils = {}
	self.m_bChecked = nil
	self.m_tRoleAniList = nil
	self.m_tMasterElement = nil
	self.m_nMasterSkillId = 0
	self.m_nDiscipleSkillId = 0
	self.m_nMasterSkillStatus = 1
	self.m_tDiscipleTeachPlsyerId = {}
	self.m_tCreateDiscipleItem = {}
	self.m_nSceneType = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
--_type  2徒弟
function WndMasterMember:createElement(_type)
	local element = WZUISystem:getInstance():createElement("WndMasterMember")
	assert(element, "WndMasterMember create element failed!")
	self:_init()
	self.m_nSceneType = _type
	return element
end
function WndMasterMember:setSceneType()
	self:setSkillButton()
end
function WndMasterMember:setMasterSkillId(skillId)
	self.m_nMasterSkillId = skillId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获得我的徒弟列表
function WndMasterMember:setMyPupils(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, sex, itemId, extraInfo, headColor, 
	bodyColor, vipLevel, serverId, bagStatus, bagType, syids, mentorSkill)
	self.m_tMyPupils = {}
	for i=1,#id do
		local tempTable = {}
		tempTable.id = id[i]
		tempTable.level = level[i]
		tempTable.name = name[i]
		tempTable.fighting = fighting[i]
		tempTable.headId = headId[i]
		tempTable.faceId = faceId[i]
		tempTable.bodyId = bodyId[i]
		tempTable.wingId = wingId[i]
		tempTable.isOnline = isOnline[i]
		tempTable.loginTime = loginTime[i]
		tempTable.sex = sex[i]
		tempTable.weaponId = itemId[i]
		tempTable.headColor = headColor[i]
		tempTable.bodyColor = bodyColor[i]
		tempTable.vipLevel = vipLevel[i]
		tempTable.extraInfo = json.decode(extraInfo[i])
		tempTable.serverId = serverId[i]
		tempTable.bagStatus = bagStatus[i]
		tempTable.bagType = bagType[i]

		table.insert(self.m_tMyPupils,tempTable)
	end
	--@brief	sort
	function _sortPupils(a,b)
		--WZLog("WndMasterMember:_sortPupils", a, b)
		--WZLog("WndMasterMember:_sortPupils", Serialize(a), Serialize(b))
		if not a or not b then return end
		--WZLog("WndMasterMember:_sortPupils",a.loginTime , b.loginTime )
		if a.isOnline == b.isOnline then
			if a.isOnline == true then
				return a.fighting > b.fighting
			else
				return a.loginTime > b.loginTime
			end
		else
			return a.isOnline
		end
	end
	table.sort(self.m_tMyPupils, _sortPupils)
	self.m_nDiscipleSkillId = mentorSkill
	for i=1, #syids do
		self.m_tDiscipleTeachPlsyerId[syids[i]] = true --已经授业过
	end
	self:update()
end
-------------------------------------私有方法模块End----------------------------------------
