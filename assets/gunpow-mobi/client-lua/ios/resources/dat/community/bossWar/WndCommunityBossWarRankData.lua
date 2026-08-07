--WndCommunityBossWarRank.lua
--@brief	WndCommunityBossWarRank的数据模块
--@date		2017/01/18
--@note		公会Boss战绩排行

WndCommunityBossWarRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityBossWarRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil 		--数据列表
	self.m_nLoadingCircleId = nil

	
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityBossWarRank:_unInit()
	self.m_root = nil
	self.m_tDataList = nil 		--数据列表
	self.m_nLoadingCircleId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityBossWarRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityBossWarRank")
	assert(element, "WndCommunityBossWarRank create element failed!")
	self:_init()
	return element
end


function WndCommunityBossWarRank:show(index)
	WZLog("WndCommunityBossWarRank:show",index)
	local element = self:createElement()
	self.pageNumber = index
	WindowManager:addWindow(element, self,nil, nil)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	取得成员列表客户端接受到服务端发送的好友列表后的数据处理回调方法 
function WndCommunityBossWarRank:setData(sectionId, fgId, fgName, fgLv, firstTime, guildId, guildName, guildLv , useTime)
	WZLog("WndCommunityBossWarRank:setData",sectionId, fgId, fgName,fgLv,firstTime,
		Serialize(guildId),Serialize(guildName),Serialize(guildLv),Serialize(useTime))
	self.m_nSectionId = sectionId
	self.m_tFirstGuildData = {}
	self.m_tFirstGuildData.isFirst = true
	self.m_tFirstGuildData.guildId = fgId
	self.m_tFirstGuildData.guildName = fgName
	self.m_tFirstGuildData.useTimeStr = firstTime
	self.m_tFirstGuildData.guildLv = fgLv

	self.m_tDataList = {}
	for i=1,#guildId do
		local tempList = {}
		tempList.guildId = guildId[i]
		tempList.guildName = guildName[i]
		tempList.useTime = useTime[i]
		tempList.guildLv = guildLv[i]
		table.insert(self.m_tDataList,tempList)
	end
	local sortFunc = function(a, b) return a.useTime < b.useTime end
	table.sort(self.m_tDataList , sortFunc)

	for i=1,#self.m_tDataList do
		data = self.m_tDataList[i]
		data.rankIndex = i
	end
	for i=1,#self.m_tDataList do
		data = self.m_tDataList[i]
		if data.guildId == CacheCenter:getPlayerInfo().guildId then
			table.remove(self.m_tDataList,i)
			table.insert(self.m_tDataList,1,data)
			break
		end
	end

	self:_update()
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end 

-------------------------------------私有方法模块End----------------------------------------
