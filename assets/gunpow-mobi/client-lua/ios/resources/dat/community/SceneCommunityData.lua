--SceneCommunityData.lua
--@brief	SceneCommunity的数据模块
--@date		2013/12/23
--@author	林庆凯
--@note		公会联盟的主场景

SceneCommunity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunity:_init()
	self.m_root = nil	 	  				  --场景根节点
	self.m_tCommunityList = nil          	  --存储从服务器返回公会列表的数据表
	self.m_tAllCommunityList = {}			  --本地存储全部公会列表
	self.m_nCurrentCellIndex = nil      	  --存储当前表格中容器的索引
	self.m_tCurrentList = nil 				  --存储当前数据的表 
	self.m_nCellCommunityId = nil       	  --用来保存从容器（CellCommunity)点击事件的取得的公会ID	
	self.m_nLoadingCircleId = nil       	  --加载圆圈的ID
	self.b_GetPlayerStoreEquipment = false    --发送玩家物品信息协议标记
	self.m_bSendGetPlayerInfo = false         --发送玩家信息协议  
	self.m_bUpPageShowLastPosition = false 	  --向上翻页，显示上一页底部 
	self.turnPage = "down"    
	self.pageNumber = 1			
	self.totalNumber = nil
	self.m_tShowList = {}					  --显示的公会列表数据
	self.m_nOffsetNum = nil				  	  --容器位置
	self.m_bFirstTurnPage = true			  --是否第一次往下翻页
	self.m_nTab = nil
	self.m_bSwitchTab = nil
	self.m_nEachPageNum = 20
	self.m_sInputContent = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunity:_unInit()
	self.m_root = nil
	self.m_tCommunityList = nil
	self.m_tAllCommunityList = nil			  --本地存储全部公会列表
	self.m_nCurrentCellIndex = nil  
	self.m_tCurrentList = nil 				  --存储当前数据的表 
	self.m_nCellCommunityId = nil  
	self.m_nLoadingCircleId = nil            --加载圆圈的ID
	self.b_GetPlayerStoreEquipment =  nil    --发送玩家物品信息协议标记
	self.m_bSendGetPlayerInfo = nil         --发送玩家信息协议   
	self.m_bUpPageShowLastPosition = nil
	self.turnPage = nil 
	self.pageNumber = nil			
	self.totalNumber = nil
	self.m_tShowList = nil					  --显示的公会列表数据
	self.m_nOffsetNum = nil				      --容器位置
	self.m_bFirstTurnPage = nil				  --是否第一次往下翻页
	self.m_nTab = nil
	self.m_bSwitchTab = nil
	self.m_nEachPageNum = nil
	self.m_sInputContent = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunity:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunity")
	assert(element, "SceneCommunity create element failed!")
	self:_init()
	return element
end

--@brief	取得自己公会的名字函数 
--@return 	自己公会的名字 
function SceneCommunity:getMyCommunityName()
	return CacheCenter:getPlayerInfo().guildName
end 

--@brief	取得公会列表（客户端接受到服务端发送的好友列表后的数据处理回调方法取得公会列表）
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneCommunity:getCommunityListNew(rank, id, name, level, prestige, totalPage, warRank, setting, rankMatchLevel, members, vipLevel)
	WZLog("SceneCommunity:getCommunityListNew",#rank,totalPage)
	self.m_tCommunityList = {}
	local myRank = -1
	for i=1,#rank do
		--if i ~= 1 and name[i] == self:getMyCommunityName() and self.m_nTab == 1 then
		if i ~= 1 and name[i] == self:getMyCommunityName() then
		else
			local tempList = {}
			tempList.communityId = id[i]
			tempList.communityName = name[i]
			tempList.level = level[i]
			tempList.prestige = prestige[i]
			tempList.rank = rank[i]
			tempList.setting = setting[i]
			tempList.rankMatchLevel = rankMatchLevel[i]
			tempList.members = members[i]
			tempList.vipLevel = vipLevel[i]
			--tempList.warRank = warRank[i]
			if tempList.rank == 0 then
				tempList.rank = LocalStrings.NONE
			end
			table.insert(self.m_tCommunityList,tempList)
		end
	end
	WZLog("收到公会列表",Serialize(self.m_tCommunityList))
	self.totalNumber = totalPage    --总页数
	--MsgBoxManager:showTipBox(totalPage)

	local index = 1
	local startIndex, endIndex
	if self.pageNumber ~= nil then
		if self.pageNumber == 1 then startIndex = 1 else startIndex = (self.pageNumber - 1)*self.m_nEachPageNum + 2 end
		endIndex = self.pageNumber * self.m_nEachPageNum + 1
		for i=startIndex,endIndex do
			self.m_tAllCommunityList[i] = self.m_tCommunityList[index]
			index = index + 1
		end
	end
	WZLog("所有公会列表",Serialize(self.m_tAllCommunityList))

	--排序
	--if #self.m_tCommunityList > 0 then
	--	table.sort(self.m_tCommunityList, _sortCommunity)
	--end

	self:_update()
	--取消圆圈的转动效果
	--MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end 

--@brief 	公会列表排序函数
function _sortCommunity(a, b)
	return a.rank < b.rank
end

--@brief	取得公会信息
function SceneCommunity:getCommunityInfoOk(id, name, level, members, chairman, desc, totemLevel, warRank, rank, declaration, prestige, setting, vipLevel)
	WZLog("SceneCommunity:getCommunityInfoOk")
	--弹出公会信息窗口
	local wndCommunityInfo = WndCommunityInfo:createElement()
	WindowManager:addWindow(wndCommunityInfo, WndCommunityInfo)
	local bHaveEnemyComminityInfo = false
	--设置公会内容
	WndCommunityInfo:setFreeconText(name,tostring(id),chairman, tostring(level),tostring(members),totemLevel,0,desc,bHaveEnemyComminityInfo, VectorToTable(warRank))

	--设置通告栏内容
	WndCommunityInfo:setFreeconsCommunityDeclareText(desc)
	--设置申请入会按钮是否可用
	local guildId = CacheCenter:getPlayerInfo().guildId
	if guildId ~= nil and guildId > 0 then
		WndCommunityInfo:setJoinCommunityBtnEnable(false)
	end
	WndCommunityInfo.setting = setting
	WndCommunityInfo.vipLevel = vipLevel
	--if CacheCenter:getPlayerInfo().level < tonumber(setting) then
	--	WndCommunityInfo:setJoinCommunityBtnEnable(false)
	--end
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end 

--@brief	取得公会信息错误处理
function SceneCommunity:getCommunityInfoError(sMessage)
	WZLog("SceneCommunity:getCommunityInfoError")
	MsgBoxManager:showTipBox(sMessage) 

	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end

--@brief	创建公会成功（COMMUNITY _CreateCommunityOk = 32）
function SceneCommunity:createCommunityOk()
	--GlobalGame.g_tPlayerInfo.nGuildId = CacheCenter:getPlayerInfo().guildId
	--GlobalGame.g_tPlayerInfo.sGuildName = CacheCenter:getPlayerInfo().guildName
	WZLog("LocalStrings.CREATE_COMMUNITY_SUCCESS = ",LocalStrings.CREATE_COMMUNITY_SUCCESS)
	SceneMyCommunity:onJumpToSceneMyCommunity()
	--显示公会建造成功
	MsgBoxManager:showTipBox(LocalStrings.CREATE_COMMUNITY_SUCCESS) 
end 

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function SceneCommunity:_getUpPage()
	local nCurPage = self.pageNumber
	if nCurPage > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function SceneCommunity:_getDownPage()
	local totalPageNum = self.totalNumber
	local nCurPage = self.pageNumber
	if nCurPage < (totalPageNum) then
		return true
	else
		return false
	end
end
-------------------------------------私有方法模块End----------------------------------------
