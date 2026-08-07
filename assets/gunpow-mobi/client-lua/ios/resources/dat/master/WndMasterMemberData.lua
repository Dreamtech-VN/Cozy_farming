--WndMasterMemberData.lua
--@brief	WndMasterMember的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒成员

WndMasterMember = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterMember:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMyMaster = nil
	self.m_tMyPupils = nil
	self.m_bChecked = false
	self.m_tRoleAniList = nil
	self.m_tMasterElement = nil
	self.m_nOnlineNum = nil
	self.m_tSendMsg = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterMember:_unInit()
	self.m_root = nil
	self.m_tMyMaster = nil
	self.m_tMyPupils = nil
	self.m_bChecked = nil
	self.m_tRoleAniList = nil
	self.m_tMasterElement = nil
	self.m_nOnlineNum = nil
	self.m_tSendMsg = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterMember:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterMember")
	assert(element, "WndMasterMember create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得我的师傅列表
function WndMasterMember:setMyMaster(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, moralityLevel, sex, itemId, extraInfo, headColor, bodyColor, graduationNum, vipLevel)
	WZLog("WndMasterMember:setMyMaster")
	self.m_tMyMaster = {}
	self.m_tSendMsg = {}
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
		tempTable.isOnline = isOnline
		tempTable.loginTime = loginTime
		tempTable.moralityLevel = moralityLevel
		tempTable.sex = sex[i]
		tempTable.weaponId = itemId[i]
		tempTable.headColor = headColor[i]
		tempTable.bodyColor = bodyColor[i]
		tempTable.vipLevel = vipLevel[i]
		if extraInfo[i] ~= nil and extraInfo ~= "" and string.len(extraInfo[i]) ~= 0 then
			WZLog("jsonDecode",name[i],type(extraInfo[i]),string.len(extraInfo[i]),extraInfo[i])
		tempTable.extraInfo = json.decode(extraInfo[i])
		end
		table.insert(self.m_tMyMaster,tempTable)
	end

	self:updateDepartment()
end

--@brief	获得我的徒弟列表
function WndMasterMember:setMyPupils(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, sex, itemId, extraInfo, headColor, bodyColor, vipLevel)
	WZLog("WndMasterMember:setMyPupils")
	self.m_tMyPupils = {}
	self.m_tSendMsg = {}
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
		table.insert(self.m_tMyPupils,tempTable)
	end

	self:update()

	if WndMasterImpart.m_root ~= nil then
		WndMasterImpart:onImpartCall()	
	end
end


-------------------------------------私有方法模块End----------------------------------------
