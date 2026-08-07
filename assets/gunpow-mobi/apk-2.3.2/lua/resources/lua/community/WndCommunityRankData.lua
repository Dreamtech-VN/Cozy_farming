--WndCommunityRankData.lua
--@brief	WndCommunityRank的数据模块
--@date		2015/10/14
--@author	zsq
--@note		公会战绩排行

WndCommunityRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil 		--数据列表
	self.m_nLoadingCircleId = nil

	self.pageNumber = nil		--当前页数
	self.totalNumber = nil		--总页数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityRank:_unInit()
	self.m_root = nil
	self.m_tDataList = nil 		--数据列表
	self.m_nLoadingCircleId = nil

	self.pageNumber = nil		--当前页数
	self.totalNumber = nil		--总页数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityRank")
	assert(element, "WndCommunityRank create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	取得成员列表客户端接受到服务端发送的好友列表后的数据处理回调方法 
function WndCommunityRank:setData(rank, id, name, war, win, score, totalPage)
	WZLog("WndCommunityRank:setData",Serialize(rank),Serialize(id),Serialize(name))
	self.totalNumber = totalPage         --总页数

	self.m_tDataList = {}
	for i=1,#id do
		local tempList = {}
		tempList.rank = rank[i]
		tempList.id = id[i]
		tempList.name = name[i]
		tempList.war = war[i]
		tempList.win = win[i]
		tempList.record = string.format(LocalStrings.COMMUNITYINFO67,war[i],win[i])
		tempList.score = score[i]
		tempList.totalPage = totalPage
		if i >= 2 then
			if self.m_nType == 1 then
				if id[i] ~= CacheCenter:getPlayerInfo().guildId then
					table.insert(self.m_tDataList,tempList)
				end
			elseif self.m_nType == 2 then
				if id[i] ~= CacheCenter:getPlayerInfo().id then
					table.insert(self.m_tDataList,tempList)
				end
			end
		else
			if tostring(rank[i]) ~= "0" then
				table.insert(self.m_tDataList,tempList)
			end
		end
	end
	
	--table.sort(self.m_tDataList , _sortMember)

	self:_update()
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end 

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndCommunityRank:_getUpPage( )
	local nCurPage = self.pageNumber
	if nCurPage > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndCommunityRank:_getDownPage()
	local totalPageNum = self.totalNumber
	local nCurPage = self.pageNumber
	if nCurPage < (totalPageNum) then
		return true
	else
		return false
	end
end


-------------------------------------私有方法模块End----------------------------------------
