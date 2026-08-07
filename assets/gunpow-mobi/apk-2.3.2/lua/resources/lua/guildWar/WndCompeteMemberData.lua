--WndCompeteMemberData.lua
--@brief	WndCompeteMember的数据模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间成员列表窗口

WndCompeteMember = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndCompeteMember:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tMemberList = nil 	--公会战房间成员列表
	self.m_tTeamPlayerId = nil 	--队伍中成员Id
	self.m_tClickCell = nil 	--点击的成员队员的cell表结构
	self.m_nLoadingId = nil 
	self.m_tNewAddId = nil 		--新进房间的会员Id
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteMember:_unInit()
	self.m_root = nil
	self.m_tMemberList = nil 	--公会战房间成员列表
	self.m_tTeamPlayerId = nil 	--队伍中成员Id
	self.m_tClickCell = nil 	--点击的成员队员的cell表结构
	self.m_nLoadingId = nil 
	self.m_tNewAddId = nil 		--新进房间的会员Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndCompeteMember:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteMember")
	assert(element, "WndCompeteMember element create failed!")
	self:_init()
	return element
end

--@brief 	公会战房间成员数据列表
function WndCompeteMember:setData(tMemberList)
	-- body
	self.m_tTeamPlayerId = {}
	--初始化队伍列表
	self:_initTeamPlayerId()

	self.m_tMemberList = CopyTable(tMemberList)
	WZLog("WndCompeteMember:setData", #self.m_tMemberList)
	
	for i = 1, #self.m_tMemberList do
		local tItem = self.m_tMemberList[i]
		if tItem and tItem.teamId > 0 then
			self.m_tTeamPlayerId[tItem.teamId][tItem.teamPosition] = tItem.id
		end
	end
	WZLog("WndCompeteMember:setData 1111", Serialize(self.m_tTeamPlayerId))
	table.sort(self.m_tMemberList, sortMember)
end

--@brief 	公会战房间成员列表排序函数
function sortMember(a, b)
	-- body
	if a.fighting ~= b.fighting then
		return a.fighting > b.fighting
	else
		if a.level ~= b.level then
			return a.level > b.level
		else
			if a.position ~= b.position then
				return a.position > b.position
			else
				if a.donate ~= b.donate then
					return a.donate > b.donate
				else
					return a.id < b.id
				end
			end
		end
	end
end

--@brief 	外部接口
--@param  	tMemberList：房间成员列表数据
function WndCompeteMember:showInterface(tMemberList)
	-- body
	if self.m_root then return end

	local wndCompeteMember = WndCompeteMember:createElement()
	if wndCompeteMember then
		WndCompeteMember:setData(tMemberList)
		WindowManager:addWindow(wndCompeteMember, WndCompeteMember)
	end
end

--@brief 	更新会员数据
function WndCompeteMember:resetData(tMemberList)
	self:setData(tMemberList)
    --刷新列表会员队伍状态
    local tbconList = GetElement(self.m_root, "tbconList_WndCompeteMember", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

    self:_createMemberList()

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
	do return end
	-- body
	self:_stopLoading()

	--新增和退房间处理
	self:_checkMemberExitRoom(tMemberList)
	self.m_tMemberList = nil 
	self.m_tMemberList = CopyTable(tMemberList)
	--新进入房间的成员
	self:_addMember(self.m_tNewAddId)
	
	self:_initTeamPlayerId()
	for i = 1, #self.m_tMemberList do
		local tItem = self.m_tMemberList[i]
		if tItem and tItem.teamId > 0 then
			self.m_tTeamPlayerId[tItem.teamId][tItem.teamPosition] = tItem.id
		end
	end
	
	WZLog("WndCompeteMember:resetData", Serialize(self.m_tTeamPlayerId))

	table.sort(self.m_tMemberList, sortMember)
	--刷新列表会员队伍状态
	local tbconList = GetElement(self.m_root, "tbconList_WndCompeteMember", WZUITableContainer)
	for i = 1, #self.m_tMemberList do
		local nTag = 0 
	    local cellElement = tbconList:getCellElement(nTag)
	    while cellElement do
	        cellElement = WZUIContainer:luaTo(cellElement)
	        local cellItem = cellElement:getChildElement("__CellCompeteMemberList")
	        if cellItem then
	            local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
	            if cellObj then
	                local nPlayerId = cellObj:getPlayerId()
	                if self.m_tMemberList[i].id == nPlayerId then 
	                    cellObj:resetTeamState(self.m_tMemberList[i].teamId)
	                    break 
	                end
	            end
	        end
	        nTag = nTag + 1
	        cellElement = tbconList:getCellElement(nTag)
	    end
	end
	--底部头像
    self:_createBottomHead()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据id返回相应的会员数据索引
function WndCompeteMember:_getDataById(id)
	-- body
	if self.m_tMemberList then
		for i = 1, #self.m_tMemberList do
			if self.m_tMemberList[i].id == id then
				return i 
			end
		end
	end

	return nil 
end

--@brief    数据加载动画
function WndCompeteMember:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndCompeteMember:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 检测列表当中是否有会员退出了房间
function WndCompeteMember:_checkMemberExitRoom(tDataList)
	-- body
	local tExitRoomId = {}
	local tTempList = CopyTable(tDataList)
	table.sort(tTempList, sortMember)
	--检索出退出房间的成员
	for i = 1, #self.m_tMemberList do
		local bExist = false 
		for j = 1, #tTempList do
			if self.m_tMemberList[i].id == tTempList[j].id then
				bExist = true
				break
			end
		end

		if bExist == false then
			table.insert(tExitRoomId, self.m_tMemberList[i].id)
		end
	end
	WZLog("WndCompeteMember:_checkMemberExitRoom", Serialize(tExitRoomId))
	--删除退出房间的会员
	self:_removeMembers(tExitRoomId)
	--检索出新进房间的成员
	self.m_tNewAddId = {}
	for i = 1, #tTempList do
		local bIsNew = true 
		for j = 1, #self.m_tMemberList do
			if self.m_tMemberList[j].id == tTempList[i].id then
				bIsNew = false
				break
			end
		end

		if bIsNew == true then
			local tItem = {}
			tItem.id = tTempList[i].id
			tItem.index = i
			table.insert(self.m_tNewAddId, tItem)
		end
	end
end

--@brief 	初始化队伍Id
function WndCompeteMember:_initTeamPlayerId()
	-- body
	self.m_tTeamPlayerId = {}

	for j = 1, 3 do
		local tItem = {}
		tItem[1] = 0
		tItem[2] = 0
		tItem[3] = 0

		table.insert(self.m_tTeamPlayerId, tItem)
	end
end
-------------------------------------私有方法模块End----------------------------------------
