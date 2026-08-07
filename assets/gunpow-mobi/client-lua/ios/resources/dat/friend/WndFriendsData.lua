--WndFriendsData.lua
--@brief	WndFriends的数据模块
--@date		2015/07/21
--@author	wuweidong
--@note		好友界面

WndFriends = {
	--请不要在这里定义变量
}

RRANK_INDEX = 1 
FRIEND_INDEX = 2
ONLINE_INDEX = 3
RECOMMEND_INDEX = 4
VIGORRECV = 1 
VIGORSEND = 2 
VIGORISRECV = 3
APPFRIEND = 1
ADDFRIEND = 2
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFriends:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurPageIndex = 1
	self.m_nTodayRecvNum = 0
	self.m_nCheckIndex = 1
	self.m_nFriendIndex = 0 
	self.m_nRecommend = 0
	self.m_tFriend = nil 
	self.m_tDynamic = nil 
	self.m_nDynamic = 0 
	self.m_tPopupMenuItems = nil
	self.m_nFriendTag = nil 
	self.m_nDynamicTag = nil 
	self.m_nLoadingId = nil 
	self.m_bAppMark = false
    self.m_nTableEmptyLabelTag = 10011
    self.m_nCurrentRowIndex = 0
    self.m_tWndBottomBarObj = nil 
    self.m_tRecommend = nil -- 推荐列表
    self.m_nOperarorType = nil 	--操作類型
    self.m_nMaxFriendliness = nil 	--最大好友度限制
    --文本
    self.FRIENDDYNAMIC = LocalStrings.FRIENDDYNAMIC
    self.NO_VATALITY_CAN_GET = LocalStrings.NO_VATALITY_CAN_GET
    self.PLEASE_SEND_AFTER_GETTING = LocalStrings.PLEASE_SEND_AFTER_GETTING
    self.PLEASE_INPUT_ID_FIRST = LocalStrings.PLEASE_INPUT_ID_FIRST
    self.ID_MUST_BE_NUMBER = LocalStrings.MASTERINFO22
    self.PLEASE_CHOOSE_PLAYER = LocalStrings.PLEASE_CHOOSE_PLAYER

    --
    self.m_bUpPageShowLastPosition = false 	  --向上翻页，显示上一页底部  	
	self.m_nOpenLayerIndex = nil 
	self.m_nFriendsTableIndex = 0 --用于加载标记用
	self.m_nDisplayedNum = NUMBER_FRIEND_PAGE --每次最多显示的好友数量
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_bIsCaculate = true 		--标记数据下标是否需要递增
	self.m_nPageUporDownIndex = 0 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
	self.m_tClickFriendData = nil 	--点击的好友cell的数据
	self.m_nDelSuccessPositionY = nil --记录删除好友时列表的位置信息
	self.m_bIsSendForUpdate = false --是否主动请求刷新动态
	self.m_bIsResetFriends = false 	--是否主动请求刷新好友列表
	self.m_nDynamicTableIndex = 0 	--用于加载动态标记
	self.m_nCleanPositionY = nil 	--列表容器clean前保存的位置
	self.m_nLastMoveElementHeight = nil --保存容器的高度
	self.m_tClickDynamic = nil 		--点击的动态的数据
	self.m_tClickedCell = nil 		--点击的cell表结构
	self.m_sMyInviteCode = nil 		--我自己的邀请码
	self.m_tInviteFriends = nil 	--邀请码好友
	self.m_tInviteTask = nil 		--邀请码任务
	self.m_nInviteFriend = 0 		
	self.m_bIsFindFriend = false 	--关键字查找是否找到
	self.m_tBlacklist = nil 		--黑名单列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFriends:_unInit()
	self.m_root = nil
	self.m_nCurPageIndex = nil
	self.m_nTodayRecvNum = nil
	self.m_nFriendIndex = nil 
	self.m_nRecommend = nil
	self.m_tFriend = nil 
	self.m_tDynamic = nil 
	self.m_tPopupMenuItems = nil
	self.m_nDynamic = nil 
	self.m_nFriendTag = nil 
	self.m_nDynamicTag = nil 
	self.m_nLoadingId = nil 
	self.m_bAppMark = nil
    self.m_nTableEmptyLabelTag = nil
    self.m_nCurrentRowIndex = 0
    self.m_tWndBottomBarObj = nil 
    self.m_tRecommend = nil -- 推荐列表 
    self.m_nOperarorType = nil 	--操作類型

    self.FRIENDDYNAMIC = nil
    self.NO_VATALITY_CAN_GET = nil
    self.PLEASE_SEND_AFTER_GETTING = nil
    --
    self.m_bUpPageShowLastPosition = nil
	self.turnPage = nil 		
	self.m_nOpenLayerIndex = nil
	self.m_nFriendsTableIndex = nil --用于加载标记用
	self.m_nDisplayedNum = nil --每次最多显示的好友数量
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_bIsCaculate = nil 		--标记数据下标是否需要递增
	self.m_nPageUporDownIndex = nil 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
	self.m_tClickFriendData = nil 	--点击的好友cell的数据
	self.m_nDelSuccessPositionY = nil --记录删除好友时列表的位置信息
	self.m_nMaxFriendliness = nil 	--最大好友度限制
	self.m_bIsSendForUpdate = nil --是否主动请求刷新动态
	self.m_bIsResetFriends = nil 	--是否主动请求刷新好友列表
	self.m_nDynamicTableIndex = nil 	--用于加载动态标记
	self.m_nCleanPositionY = nil 	--列表容器clean前保存的位置
	self.m_nLastMoveElementHeight = nil  --保存容器的高度
	self.m_tClickDynamic = nil 		--点击的动态的数据
	self.m_tClickedCell = nil 		--点击的cell表结构
	self.m_sMyInviteCode = nil 		--我自己的邀请码
	self.m_tInviteFriends = nil 	--邀请码好友
	self.m_tInviteTask = nil 		--邀请码任务
	self.m_nInviteFriend = nil 
	self.m_bIsFindFriend = nil 
	self.m_tBlacklist = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFriends:createElement()
	if self.m_root then
        WindowManager:removeWindow(self.m_root,WndFriends)
    end

	local element = WZUISystem:getInstance():createElement("WndFriends")
	assert(element, "WndFriends create element failed!")
	self:_init()
	return element
end

--@brief	刷新界面
--@param 	result : >0 增加的好友度， =0 或 = nil ,不处理
function WndFriends:RefreshInterface(mark,bRefresh,index, result)
	if self.m_root == nil then
		return
	end
	local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
	
	mark = mark or 0 
	bRefresh = bRefresh or 1
	if self.m_nCheckIndex == RRANK_INDEX then
		--暂无数据处理
	elseif self.m_nCheckIndex == FRIEND_INDEX then 
		removeShowPanelNullTip(conFriendList_WndFriends)
        if index ~= nil and  index > 0 then 
        	self:closeLoading()
        	WZLog("赠送tag为"..CellFriends.m_current_click.tag)
        	local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))  
        	local cellElement = tbconFriend:getCellElement(CellFriends.m_current_click.tag)
        	cellElement = WZUIContainer:luaTo(cellElement)
        	local cellItem = cellElement:getChildElement("__CellFriends")
        	WZLog("555555555555", type(cellItem))
        	local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
        	--更新好友的好友度
        	if result ~= nil and result > 0 then
        		local friendId = cellObj:getFriendId()
        		CacheCenter:UpdateFriendLinessAfterGift(friendId, result)
        		local tFriendList = CacheCenter:getFriendList()
        		for i = 1, #tFriendList do
        			if tFriendList[i].id == friendId then
        				cellObj:updateFriendlinessValue(tFriendList[i].friendliness)
        				break
        			end
        		end
        	else
        		WZLog("Vigor Operation Refresh FriendLiness")
        		local tFriendList = CacheCenter:getFriendList()
        		local friendIdClick = cellObj:getFriendId()
        		for i = 1, #tFriendList do
        			if tFriendList[i].id == friendIdClick then
        				cellObj:updateFriendlinessValue(tFriendList[i].friendliness)
        				break
        			end
        		end
        		
        	end
        	cellObj:setSend(false)
        	cellObj:_showFrameIndex()
        else 
			self:setFriendData(CacheCenter:getFriendList())
		end 
	elseif self.m_nCheckIndex == ONLINE_INDEX then
		removeShowPanelNullTip(conFriendList_WndFriends)
		if index~=nil and index > 0 then 
			self:closeLoading()
			local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))  
			if self.m_nOperarorType ~= 1 then
	        	local cellElement = tbconFriend:getCellElement(CellDynamic.m_current_click.tagT)
	        	cellElement = WZUIContainer:luaTo(cellElement)
	        	local cellItem = cellElement:getChildElement("__CellDynamic")
	        	local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
	        	local tData = cellObj:getData()
	        	if tData.typeList == 4 then
	        		CacheCenter:updateDynamicList(tData)
	        		--移除处理的好友申请
	        		local nCurPositionY = tbconFriend:getMoveElement():getPositionY()
	        		local nLastSize = tbconFriend:getMoveElement():getContentSize()

				    tbconFriend:removeCellElementByReset(CellDynamic.m_current_click.tagT)
				    for i = 1, #self.m_tDynamic do
				    	if self.m_tDynamic[i].typeList == 4 and self.m_tDynamic[i].id == tData.id then
				    		table.remove(self.m_tDynamic, i)
				    		break 
				    	end
				    end
					--刷新好友数量显示
					self:updateFriendsNum()
					if self.m_tDynamic == nil or #self.m_tDynamic == 0 then
						self:_showEmptyTip(#self.m_tDynamic,LocalStrings.EMPTYFRIENDTIP2,true)
						return 
					end

					self.m_nDynamic = self.m_nDynamic - 1
					--移除后列表的处理
					if self.m_nDynamic > 0 then
						self:_dealWithDelDynamic(tbconFriend, nCurPositionY, nLastSize)
					end	
				elseif tData.typeList == 7 then
					CacheCenter:updateDynamicList(tData)
	        		--移除处理的好友申请
	        		local nCurPositionY = tbconFriend:getMoveElement():getPositionY()
	        		local nLastSize = tbconFriend:getMoveElement():getContentSize()

				    tbconFriend:removeCellElementByReset(CellDynamic.m_current_click.tagT)
				    for i = 1, #self.m_tDynamic do
				    	if self.m_tDynamic[i].typeList == 7 and self.m_tDynamic[i].id == tData.id then
				    		table.remove(self.m_tDynamic, i)
				    		break 
				    	end
				    end
					--刷新好友数量显示
					self:updateFriendsNum()
					if self.m_tDynamic == nil or #self.m_tDynamic == 0 then
						self:_showEmptyTip(#self.m_tDynamic,LocalStrings.EMPTYFRIENDTIP2,true)
						return 
					end

					self.m_nDynamic = self.m_nDynamic - 1
					--移除后列表的处理
					if self.m_nDynamic > 0 then
						self:_dealWithDelDynamic(tbconFriend, nCurPositionY, nLastSize)
					end	
				elseif tData.typeList == 9 then
					CacheCenter:updateDynamicList(tData)
	        		--移除处理的好友申请
	        		local nCurPositionY = tbconFriend:getMoveElement():getPositionY()
	        		local nLastSize = tbconFriend:getMoveElement():getContentSize()

				    tbconFriend:removeCellElementByReset(CellDynamic.m_current_click.tagT)
				    for i = 1, #self.m_tDynamic do
				    	if self.m_tDynamic[i].typeList == 9 and self.m_tDynamic[i].id == tData.id then
				    		table.remove(self.m_tDynamic, i)
				    		break 
				    	end
				    end
					
					if self.m_tDynamic == nil or #self.m_tDynamic == 0 then
						self:_showEmptyTip(#self.m_tDynamic,LocalStrings.EMPTYFRIENDTIP2,true)
						return 
					end

					self.m_nDynamic = self.m_nDynamic - 1
					--移除后列表的处理
					if self.m_nDynamic > 0 then
						self:_dealWithDelDynamic(tbconFriend, nCurPositionY, nLastSize)
					end
	        	else
		        	local tDynamic = CacheCenter:getDynamicFriendList()
		        	self.m_tDynamic = CopyTable(tDynamic)
		        	local nDataIndex = 1
					for idx = 1, #self.m_tDynamic do
						if self.m_tDynamic[idx].id == self.m_tClickDynamic.id and self.m_tDynamic[idx].typeList == self.m_tClickDynamic.typeList then
							nDataIndex = idx
							break 
						end
					end
		        	cellObj:_showGiftButton(self.m_tDynamic[nDataIndex].status, self.m_tDynamic[nDataIndex].sendType, self.m_tDynamic[nDataIndex].typeList)
		        	--刷新左下角的可领取数量
		        	--Add By Tianxiang_Xu
		        	self:updateFriendsNum()
		    	end
		    else
		    	--在推缓存推送时刷新界面
		    end
		else 
			if bRefresh == 1 then
				self:setDynamicData(CacheCenter:getDynamicFriendList())
			end
		end 
	elseif self.m_nCheckIndex == INVITE_INDEX then
		if index == 1 then 
			self.m_tInviteFriends = nil 
			self.m_tInviteFriends = CopyTable(CacheCenter:getInviteFriendList())

		    if self.m_nInviteFriend - self.m_nDisplayedNum <= 0 then
		        self.m_nInviteFriend = 0 
		        if #self.m_tInviteFriends < self.m_nDisplayedNum then 
		            self.m_nCurNeedLoadNum = #self.m_tInviteFriends
		        else
		            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
		        end
		        self.m_nCurLoadIndex = 1
		    else
		        self.m_nInviteFriend = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
		        self.m_nCurNeedLoadNum = #self.m_tInviteFriends - (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
		        if self.m_nCurNeedLoadNum > self.m_nDisplayedNum then
		            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
		        end
		        self.m_nCurLoadIndex = self.m_nInviteFriend + 1
		    end

		    local tbInviteFriends = GetElement(self.m_root, "tbInviteFriends_WndFriends", WZUITableContainer)
		    local tLastSize = tbInviteFriends:getMoveElement():getContentSize()
          	self.m_nLastMoveElementHeight = tLastSize.height
          	self.m_nCleanPositionY = tbInviteFriends:getMoveElement():getPositionY()
		    self.m_nCurTag = 0 
			self:_updateInviteFriends()
		elseif index == 2 then 
			self.m_tInviteTask = nil 
			self.m_tInviteTask = CopyTable(CacheCenter:getInviteTaskList())
			local tbInviteRewards = GetElement(self.m_root, "tbInviteRewards_WndFriends", WZUITableContainer)
			--保存当前列表位置
			self.m_nCleanPositionY = tbInviteRewards:getMoveElement():getPositionY()
			self:_updateInviteTask()
		end
	end
	if mark == 1 then 
		self.m_bAppMark = true 
		self:showDynamicMark(self.m_bAppMark)
	end
end

--@brief 	重新刷新动态列表
function WndFriends:RefreshDynamicList()
	-- body
	if self.m_root == nil then return end
	WZLog("WndFriends:RefreshDynamicList")
	if self.m_nCheckIndex == ONLINE_INDEX then 
		if self.m_bIsSendForUpdate then
			WZLog("WndFriends:RefreshDynamicList 主动更新动态")
			self:closeLoading()
			self.m_bIsSendForUpdate = false
			if CacheCenter:getDynamicFriendList() == nil then 
		        self.m_tDynamic = nil 
		        self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP2,true)
		        return 
		    end
			if #CacheCenter:getDynamicFriendList() > 0 then 
				local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
				removeShowPanelNullTip(conFriendList_WndFriends)
			end
			self:setDynamicData(CacheCenter:getDynamicFriendList())
		else
			self:setDynamicData(CacheCenter:getDynamicFriendList())
		end
	end
end

--@brief	好友数据列表
function WndFriends:setFriendData(tFriend)
	if self.m_root == nil then
		return		
	elseif tFriend == nil or #tFriend == 0 then	
		self.m_tFriend = nil 
		self:_showFriendNum()
		self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP1,true)
		self:closeLoading()
		local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
		tbconFriend:cleanTable()
		return 
	end
	if self.m_bIsResetFriends == true then
		WZLog("WndFriends:setFriendData 主动刷新好友")
		self.m_bIsResetFriends = false
		self:closeLoading()
		if CacheCenter:getFriendList() == nil then 
	        self.m_tFriend = nil 
			self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP1,true)
	        return 
	    end
	    if #CacheCenter:getFriendList() > 0 then 
	        local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
	        removeShowPanelNullTip(conFriendList_WndFriends)
	    end
	    self:setFriendData(CacheCenter:getFriendList())
	    self:_showFriendCount(true)
	    self:_showFriendNum()
	else
		self:closeLoading()
		self.m_tFriend = {}
		for i,data in pairs(tFriend) do 
			if data.type == 1 then
				table.insert(self.m_tFriend,data)
			end
		end
		if self.m_tFriend == nil or #self.m_tFriend == 0 then
			self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP1,true)
			return
		end
		self:_sortFriendListType()--排序类型	
		self:_updateFriend()
		self:_showEmptyTip(#self.m_tFriend)
		WZLog("好友数据列表::",#tFriend,#self.m_tFriend)
	end
end

--@brief	好友动态数据列表
function WndFriends:setDynamicData(tDynamic)
	if self.m_nCheckIndex == ONLINE_INDEX then
		if self.m_root == nil then
			return
		elseif tDynamic == nil or #tDynamic == 0 then 
			self.m_tDynamic = nil 
			self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP2,true)
			self:closeLoading()
			return 
		end
		self:closeLoading()
		
		self.m_tDynamic = CopyTable(tDynamic)
		self:_sortFriendListType()--排序类型	
		self:_updateDynamicFriend()	
		self:_showEmptyTip(#self.m_tDynamic,LocalStrings.EMPTYFRIENDTIP2,true)
	end
end

--@brief 	推荐列表数据
function WndFriends:setRecommendData(playerId, playerName, level, fighting, headId, faceId, sex, online, vipLevel, headColor)
	self:closeLoading()
	if self.m_root == nil then
		return
	end
	if playerId:size() == 0 then
		local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
    	tbconFriend:cleanTable()
		self.m_tRecommend = nil 
		self:_showEmptyTip(0,LocalStrings.FRIENDS_SEND_TIP_3,true)
		return 
	end
	local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
	removeShowPanelNullTip(conFriendList_WndFriends)
	
	WZLog("WndFriends:setRecommendData()::::", playerId:size())
	self.m_nCount = 10
	self.m_nRecommend = 0
	self.m_tRecommend = {}
	for i=0,playerId:size()-1 do
		local level,reinc = self:_getLevelReic(level:get(i))
		local temp = {}
		temp.id = playerId:get(i)
		temp.time = 0
		temp.fighting = fighting:get(i)
		temp.name = playerName:get(i)
		temp.level = level
		temp.headItemId = headId:get(i)
		temp.faceItemId = faceId:get(i)
		-- if online:get(i) == 1 then
		-- 	temp.isOnline = true
		-- else
		-- 	temp.isOnline = false
		-- end
		temp.isOnline = online:get(i)
		temp.sex = sex:get(i)
		temp.vipLevel = vipLevel:get(i)
		temp.headColor = headColor:get(i)
		temp.reinc = reinc --转生
		table.insert(self.m_tRecommend,temp)
	end
	table.sort(self.m_tRecommend , sortFriends)
	WZLog("*****22222****", Serialize(self.m_tRecommend))
	self:_updateRecommend()
end

--@brief 	黑名单列表数据
function WndFriends:setBlacklistData(playerId, playerName, level, fighting, headId, faceId, sex, online, vipLevel, headColor)
	self:closeLoading()
	if self.m_root == nil then
		return
	end
	if playerId:size() == 0 then
		local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
    	tbconFriend:cleanTable()
		self.m_tRecommend = nil 
		self:_showEmptyTip(0,LocalStrings.FRIENDS_SEND_TIP_3,true)
		return 
	end
	local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
	removeShowPanelNullTip(conFriendList_WndFriends)
	
	WZLog("WndFriends:setRecommendData()::::", playerId:size())
	self.m_nCount = 10
	self.m_nRecommend = 0
	self.m_tRecommend = {}
	for i=0,playerId:size()-1 do
		local level,reinc = self:_getLevelReic(level:get(i))
		local temp = {}
		temp.id = playerId:get(i)
		temp.time = 0
		temp.fighting = fighting:get(i)
		temp.name = playerName:get(i)
		temp.level = level
		temp.headItemId = headId:get(i)
		temp.faceItemId = faceId:get(i)
		-- if online:get(i) == 1 then
		-- 	temp.isOnline = true
		-- else
		-- 	temp.isOnline = false
		-- end
		temp.isOnline = online:get(i)
		temp.sex = sex:get(i)
		temp.vipLevel = vipLevel:get(i)
		temp.headColor = headColor:get(i)
		temp.reinc = reinc --转生
		table.insert(self.m_tRecommend,temp)
	end
	table.sort(self.m_tRecommend , sortFriends)
	WZLog("*****22222****", Serialize(self.m_tRecommend))
	self:_updateRecommend()
end

--@brief   创建加载框
function WndFriends:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFriends:closeLoading()
	if self.m_root == nil then
		return
	end
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


--@brief 	重新更新提示好友上线数据
function WndFriends:resetRemindFriends(tNeedRemindList)
	--body
	for i,data in pairs(self.m_tFriend) do 
		data.isOnlineRemind = 0
		for k = 1, #tNeedRemindList do 
			if tonumber(data.id) == tNeedRemindList[k].id then
				data.isOnlineRemind = 1
			end
		end
	end
end

--@brief 	设置邀请好友任务数据
function WndFriends:setInviteTaskData()
	-- body
	self:closeLoading()
	
	if self.m_root == nil then return end

	self.m_tInviteTask = nil 
	self.m_tInviteFriends = nil 

	self.m_sMyInviteCode = CacheCenter:getMyInviteCode()
	self.m_tInviteTask = CopyTable(CacheCenter:getInviteTaskList())
	self.m_tInviteFriends = CopyTable(CacheCenter:getInviteFriendList())

	if #self.m_tInviteFriends < self.m_nDisplayedNum then 
        self.m_nCurNeedLoadNum = #self.m_tInviteFriends
    else
        self.m_nCurNeedLoadNum = self.m_nDisplayedNum
    end
    self.m_nCurLoadIndex = 1

    self:onShowInvite()
end

--@brief 	获取邀请码任务成功
function WndFriends:receiveTaskRewardOK(rewardId, items, nums)
	-- body
	local checkTheme5 = GetElement(self.m_root,"checkTheme5_WndFriends",WZUICheckBox)
	if not checkTheme5:isVisible() then
		return
	end
	
	if self.m_root == nil then return end 
	WZLog("WndFriends:receiveTaskRewardOK", CacheCenter.m_nInviteMark)
	self:closeLoading()
	CacheCenter.m_nInviteMark = CacheCenter.m_nInviteMark - 1 
	if CacheCenter.m_nInviteMark > 0 then
        self:showInviteMark(true)
    else
        self:showInviteMark(false)
    end
	CacheCenter:refreshInviteTask(rewardId, 1)
	WndRewardShow:showById(items, nums)
end

--@brief 	添加黑名单成功
function WndFriends:addBlacklistOK()
	-- body
	if self.m_root == nil then return end 
	if self.m_nCheckIndex ~= BLACKLIST_INDEX then return end 

	self:onShowBlacklist()
end

--@brief 	同意双修成功
function WndFriends:agreeDoublePracticeSuccess(result)
	-- body
	WndBagMain:showPractice()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFriends:_getLevelReic(level)
	if level < GlobalGame.g_ReincPlayerLeve then
		return level ,false 
	end
	return level - GlobalGame.g_ReincPlayerLeve ,true
end

function WndFriends:_getDataList()
	if self.m_nCheckIndex == RRANK_INDEX then
		return 
	elseif self.m_nCheckIndex == FRIEND_INDEX then
		return self.m_tFriend--好友排序
	elseif self.m_nCheckIndex == ONLINE_INDEX then
		return self.m_tDynamic--玩家动态排序
	end
end

function WndFriends:_sortFriendListType()
	if self.m_root == nil or self:_getDataList() == nil then
		return
	end
	if self.m_nCheckIndex == RRANK_INDEX then
		table.sort(self.m_tFriend , sortRankings)
	elseif self.m_nCheckIndex == FRIEND_INDEX then
		table.sort(self.m_tFriend , sortFriends)--好友排序
	elseif self.m_nCheckIndex == ONLINE_INDEX then
		table.sort(self.m_tDynamic , sortDynamicFriends)--玩家动态排序
	end
end

--@note		排行排序
function sortRankings(a,b)
	if a.level ~= b.level then
		return a.level >= b.level
	elseif a.fighting ~= b.fighting then
		return a.fighting >= b.fighting
	else 
		return a.id < b.id 
	end
end

--@note		好友排序
function sortFriends(a,b)
	local onlineA = WndFriends:checkSortOnline(a)
	local onlineB = WndFriends:checkSortOnline(b)
	local relationA = WndFriends:checkSortRelation(a)
	local relationB = WndFriends:checkSortRelation(b)
	local offTimeA = WndFriends:checkOutlineTime(a)
	local offTimeB = WndFriends:checkOutlineTime(b)
	if onlineA ~= onlineB then
		return onlineA >= onlineB
	elseif offTimeA ~= offTimeB then 
		return offTimeA < offTimeB
	elseif relationA ~= relationB then 
		return relationA > relationB
	elseif a.friendliness ~= b.friendliness then
		return  a.friendliness > b.friendliness
	elseif a.level ~= b.level then
		return a.level >= b.level
	elseif a.fighting ~= b.fighting then
		return a.fighting >= b.fighting
	else
		return a.id < b.id 
	end
end

--@brief 	
function WndFriends:checkOutlineTime(a)
	-- body
	local offlineTime = a.offlineTime or 0
	local curTime = SystemTime:getServerTime()
    local nTime = curTime - offlineTime
    if offlineTime <= 0 then 
    	return 3
    elseif nTime > 30 * 24 * 3600 then
    	return 2
    else 
    	return 1
    end
end

function WndFriends:checkSortOnline(a)
	if a.isOnline == 1 or a.isOnline == true then
		return 2 
	else 
		return 1 
	end
end

function WndFriends:checkSortRelation(a)
	if a.relation == 2 then
		return 5 
	elseif a.relation == 1 then
		return 4
	elseif a.bBestFriend == 1 then
		return 3
	elseif a.isMentoring == 1 or a.isMentoring == 2 then
		return 2
	else 
		return 1 
	end
end

--@note		在线玩家排序
function sortDynamicFriends(a,b)
	local operateA = WndFriends:checkSortOperate(a)
	local operateB = WndFriends:checkSortOperate(b)

	if operateA ~= operateB then
		return operateA > operateB
	elseif a.time == nil or b.time == nil then
        return false
    end

	if a.time ~= b.time then
		return a.time >= b.time
	end
end

function WndFriends:checkSortOperate(a)
	if a.typeList == 4 then
		return 4
	elseif a.status == 1 then
		return 3
	elseif a.sendType == 1 then
		return 2 
	else 
		return 1 
	end
end

--@note		显示文本文字
function WndFriends:_showTTFText(name,desc)
	local element = WZUILabelTTF:luaTo(self.m_root:getChildElement(name))
	element:setText(desc)
	return element
end

--@note		设置两个文本的颜色
function WndFriends:_show2ColorTTF(leftName,rightName,rightDesc)
	local leftTxt = WZUILabelTTF:luaTo(self.m_root:getChildElement(leftName))
	local rightTxt = WZUILabelTTF:luaTo(self.m_root:getChildElement(rightName))
	rightTxt:setText(rightDesc)
	leftTxt:setVisible(false)
	rightTxt:setVisible(false)
	leftTxt:setVisible(true)
	rightTxt:setVisible(true)
end

--@brief   	获取一帧创建多少个列表数量
--@param   	element:列表容器的节点
function WndFriends:_getOneFrameCount(element,tFriend)
	if tFriend == nil or element == nil then
		element:disableSchedule()
		return 0
	end
	local mailCount = #tFriend
	local nMailTime = 1
	local nTime = mailCount - self:_getIndex()
	if nTime < nMailTime then
		nMailTime = nTime
		element:disableSchedule()--停止定时器
	end
	return nMailTime
end

function WndFriends:_getIndex()
	if self.m_nCheckIndex == ONLINE_INDEX then
		return self.m_nDynamic
	elseif self.m_nCheckIndex == FRIEND_INDEX then
		return self.m_nFriendIndex
	elseif self.m_nCheckIndex == RECOMMEND_INDEX then
		return self.m_nRecommend
	end
end

--@brief	空数据提示语
function WndFriends:_showEmptyTip(count,desc,isPic)
	local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
	removeShowPanelNullTip(conFriendList_WndFriends)
	if count > 0 then
		return
	else
        local tbcon = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
        tbcon:setEnableDropRefresh(false)
		tbcon:setEnableTopElement(false)
		tbcon:setHideTopElement(true)
		tbcon:setEnableDagLoading(false)
		tbcon:setEnableBottomElement(false)
		tbcon:setHideBottomElement(true)
		if self.m_bIsFindFriend then
			desc = LocalStrings.SEARCH_NO_RESULT
		end
        ShowPanelNullTip(conFriendList_WndFriends, desc)
        --end 
	end
end

function WndFriends:clear()
	local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
    if tbconFriend:getChildByTag(self.m_nTableEmptyLabelTag) then
        tbconFriend:removeChildByTag(self.m_nTableEmptyLabelTag,true)
    end
    WZLog("tbconFriend:stopMoveAction")
    tbconFriend:stopMoveAction()
    tbconFriend:disableSchedule()
	tbconFriend:cleanTable()
end


--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndFriends:_getUpPage(nFriendsTableIndex, nIndex)
	local nFriendsIndex = nIndex or nFriendsTableIndex
	WZLog("****** WndFriends:_getUpPage ******", nFriendsTableIndex, self.m_nDisplayedNum)
	local nCurPage = nFriendsIndex - self.m_nDisplayedNum
	if nCurPage > 0 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndFriends:_getDownPage(nFriendNum, nIndex)
	local nCurPage = nFriendNum - nIndex
	WZLog("****** WndFriends:_getDownPage ******", nFriendNum, nIndex)
	if nCurPage > 0 then
		return true
	else
		return false
	end
end
-------------------------------------私有方法模块End----------------------------------------
