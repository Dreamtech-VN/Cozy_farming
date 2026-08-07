--WndLeagueVSInfoData.lua
--@brief	WndLeagueVSInfo的数据模块
--@date		2016/06/21
--@author	Tianxiang_Xu
--@note		查看回放确认界面

WndLeagueVSInfo = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndLeagueVSInfo:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tLeftData = nil 
	self.m_tRightData = nil 
	self.m_nLoadingId = nil 
	self.m_nRecordId = nil 
	self.m_nTypeId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeagueVSInfo:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tLeftData = nil 
	self.m_tRightData = nil 
	self.m_nLoadingId = nil 
	self.m_nRecordId = nil 
	self.m_nTypeId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndLeagueVSInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeagueVSInfo")
	assert(element, "WndLeagueVSInfo element create failed!")
	self:_init()
	return element
end

--@brief 	设置数据
function WndLeagueVSInfo:setData(playerId, faceId, headId, name, sex, camp, mvp, teamId, level, headColor)
	-- body
	if self.m_tData == nil then 
		self.m_tData = {}
	end

	self.m_tData.tLeftTeamData = {}
	self.m_tData.tLeftTeamData.teamIcon = self.m_tLeftData.teamIcon
	self.m_tData.tLeftTeamData.teamId = self.m_tLeftData.teamId
	self.m_tData.tLeftTeamData.teamName = self.m_tLeftData.teamName
	self.m_tData.tLeftTeamData.player = {}
	
	self.m_tData.tRightTeamData = {}
	self.m_tData.tRightTeamData.teamIcon = self.m_tRightData.teamIcon
	self.m_tData.tRightTeamData.teamId = self.m_tRightData.teamId
	self.m_tData.tRightTeamData.teamName = self.m_tRightData.teamName
	self.m_tData.tRightTeamData.player = {}

	for i = 0, playerId:size() - 1 do
		if self.m_tData.tLeftTeamData.teamId == teamId:get(i) then
			local tItem = {}
			tItem.id = playerId:get(i)
			tItem.faceId = faceId:get(i)
			tItem.headId = headId:get(i)
			tItem.name = name:get(i)
			tItem.sex = sex:get(i)
			tItem.level = level:get(i)
			tItem.headColor = headColor:get(i)

			table.insert(self.m_tData.tLeftTeamData.player, tItem)
		elseif self.m_tData.tRightTeamData.teamId == teamId:get(i) then
			local tItem = {}
			tItem.id = playerId:get(i)
			tItem.faceId = faceId:get(i)
			tItem.headId = headId:get(i)
			tItem.name = name:get(i)
			tItem.sex = sex:get(i)
			tItem.level = level:get(i)
			tItem.headColor = headColor:get(i)

			table.insert(self.m_tData.tRightTeamData.player, tItem)
		end
	end
	self:_closeLoading()
	WZLog("WndLeagueVSInfo:setData", Serialize(self.m_tData))

	self:_update()
end

--@brief 	外部接口
--@param 	typeId:2->精彩回放；3->决赛回放
--@param 	team1Data:左队信息
--@param 	team2Data:右队信息
function WndLeagueVSInfo:showInterface(id, typeId, team1Data, team2Data)
	-- body
	if self.m_root ~= nil then 
		self:onCloseActionCallback()
	end

	local wndLeagueVSInfo = WndLeagueVSInfo:createElement()
	if wndLeagueVSInfo then
		self.m_tLeftData = team1Data
		self.m_tRightData = team2Data
		self.m_nRecordId = id
		self.m_nTypeId = typeId
		WindowManager:addWindow(wndLeagueVSInfo, WndLeagueVSInfo)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
