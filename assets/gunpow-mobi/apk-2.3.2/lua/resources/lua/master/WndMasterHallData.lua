--WndMasterHallData.lua
--@brief	WndMasterHall的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒大厅

WndMasterHall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterHall:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tMasterHall = {}
	self.m_nRefreshTime = nil
	self.m_bChecked = false
	self.m_tRoleAniList = nil
	self.m_nStartIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterHall:_unInit()
	self.m_root = nil
	self.m_tMasterHall = {}
	self.m_nRefreshTime = nil
	self.m_bChecked = nil
	self.m_tRoleAniList = nil
	self.m_nStartIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterHall:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterHall")
	assert(element, "WndMasterHall create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得公会大厅数据
function WndMasterHall:setMasterHall(id, title, level, name, fighting, headId, faceId, bodyId, wingId, pet, isOnline, sex, itemId, extraInfo, headColor, bodyColor, vipLevel, serverId)
	self.m_tMasterHall = {}
	WndMasterMember.m_tSendMsg = {}
	local playerInfo = CacheCenter:getPlayerInfo()
	for i=1,#id do
		local tempTable = {}
		tempTable.id = id[i]
		tempTable.title = title[i]
		tempTable.level = level[i]
		tempTable.name = name[i]
		tempTable.fighting = fighting[i]
		tempTable.headId = headId[i]
		tempTable.faceId = faceId[i]
		tempTable.bodyId = bodyId[i]
		tempTable.wingId = wingId[i]
		tempTable.pet = pet[i]
		tempTable.isOnline = isOnline[i]
		tempTable.sex = sex[i]
		tempTable.weaponId = itemId[i]
		tempTable.extraInfo = ""
		if extraInfo[i] then
			tempTable.extraInfo = json.decode(extraInfo[i])
		end
		tempTable.headColor = headColor[i]
		tempTable.bodyColor = bodyColor[i]
		tempTable.vipLevel = vipLevel[i]
		tempTable.serverId = serverId[i]
		--师傅显示收徒或拜师的按钮
		local state = 1 --拜师
		if playerInfo.level >= 35 and playerInfo.level > level[i] and playerInfo.fighting > fighting[i] then
			state = 2 --收徒
		end
		tempTable.state = state
		table.insert(self.m_tMasterHall,tempTable)
	end
	WZLog("WndMasterHall:setMasterHall",Serialize(self.m_tMasterHall))

	self:update()
end




-------------------------------------私有方法模块End----------------------------------------
