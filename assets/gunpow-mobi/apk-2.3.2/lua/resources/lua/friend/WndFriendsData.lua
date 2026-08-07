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
	self.m_bIsClickAddCircle = false 	--是否是添加心情界面
	self.m_tMyCircleData = nil 		--我的心情数据
	self.m_tFriendCircleData = nil 		--好友圈数据
	self.m_tHotCircleData = nil 		--热点心情数据
	self.m_tAddPhotoData = nil 			--添加心情时候添加的图片信息
	self.m_nUploadTime = 0
	self.m_bUploading = false 
	self.m_nLoadingCircleId = nil 
	self.m_nForbidIndex = 0 			--非好友是否能评论:0开启 1关闭
	self.m_nUploadPhotoIndex = 0	--上传图片索引
	self.m_nNewMessageNum = 0 		--未读信息的条数
	self.m_tNewMessageData = nil 	--未读消息列表
	self.m_nSpecifyCheckIndex = nil --指定的标签
	self.m_tExtendCircle = {} 		--保存本次展开评论的圈Id
	self.m_nNeedUploadPhotoNum = 0 		--需要上传的图片数量
	self.m_nHavedUploadNum = 0 		--已上传上传的图片数量
	self.m_tDownloadFileList = nil		--待下载的文件列表 
	self.m_nDefaultShowCommentNum = nil 
	self.m_tCellBeingComment = nil 		--正在评论的Cell

	self.m_tSelFriends = nil 		--选中的好友
	self.m_bIsFilterFriend = false 	--是否筛选好友
	self.m_nCurIndex = nil 			--师徒标签索引
	self.m_tHallElement = nil 		--师徒大厅
	self.m_tMemberElement = nil 	
	self.m_tRewardElement = nil
	self.m_tLogElement = nil
	self.m_tTarget = nil
	self.m_sDisciple = nil
	self.m_nOrder = 0
	self.m_MarryHall = nil
	self.m_nCountDownTime1 = -1
	self.m_nCountDownScheduleId1 = nil
	self.m_bIsMasterUpgrade = nil --是否存在升级
	self.m_tBestFriendsCell = nil 	--密友Cell
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

	self.m_bIsClickAddCircle = nil 
	self.m_tMyCircleData = nil 
	self.m_tFriendCircleData = nil 		--好友圈数据
	self.m_tHotCircleData = nil 		--热点心情数据
	self.m_tAddPhotoData = nil 			--添加心情时候添加的图片信息
	self.m_nUploadTime = nil 
	self.m_bUploading = nil 
	self.m_nLoadingCircleId = nil 
	self.m_nForbidIndex = nil  			--非好友是否能评论
	self.m_nUploadPhotoIndex = nil 
	self.m_nNewMessageNum = nil 
	self.m_tNewMessageData = nil
	self.m_nSpecifyCheckIndex = nil 
	self.m_tExtendCircle = nil 
	self.m_nNeedUploadPhotoNum = nil 
	self.m_nHavedUploadNum = nil 
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_nDefaultShowCommentNum = nil 
	self.m_tCellBeingComment = nil 		--正在评论的Cell

	self.m_tSelFriends = nil 		--选中的好友
	self.m_bIsFilterFriend = nil 
	self.m_nCurIndex = nil
	self.m_tHallElement = nil
	self.m_tMemberElement = nil
	self.m_tRewardElement = nil
	self.m_tLogElement = nil
	self.m_tTarget = nil
	self.m_sDisciple = nil
	self.m_nOrder = nil
	self.m_MarryHall = nil
	self.m_nCountDownTime1 = -1
	self.m_nCountDownScheduleId1 = nil
	self.m_bIsMasterUpgrade = nil
	self.m_tBestFriendsCell = nil
end
function WndFriends:setMasterUpgrade(bBool)
	self.m_bIsMasterUpgrade = bBool
end
function WndFriends:getMasterUpgrade()
	return self.m_bIsMasterUpgrade
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

--@brief 	跳转到相应的标签
--@param 	nCheckIndex：打开的标签索引
--@param 	bClickAddCircle : 是否打开添加心情界面
--@note 	只做了圈的跳转
function WndFriends:showInterface(nCheckIndex, bClickAddCircle)
    -- body
    if nCheckIndex == FRIENDCIRCLE_INDEX then 
    	if not CheckButtonOpen(165) then return end 
    elseif nCheckIndex == HOTCIRCLE_INDEX then 
    	if not CheckButtonOpen(166) then return end 
    elseif nCheckIndex == MYCIRCLE_INDEX then 
    	if not CheckButtonOpen(167) then return end 
    end

    local wndFriends = WndFriends:createElement()
    if wndFriends ~= nil then
    	self.m_nSpecifyCheckIndex = nCheckIndex
    	self.m_bIsClickAddCircle = bClickAddCircle or false 
        WindowManager:addWindow(wndFriends,WndFriends)
    end
end

--@brief	刷新界面
--@param 	result : >0 增加的好友度， =0 或 = nil ,不处理
function WndFriends:RefreshInterface(mark,bRefresh,index, result, playerId)
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
        	if CellFriends and CellFriends.m_current_click and CellFriends.m_current_click.tag then
	        	WZLog("赠送tag为"..CellFriends.m_current_click.tag)
	        	local tbconFriend = self:getCurUsingTableContainer()
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
	        end
	        self:_updateModel()
        else 
			self:setFriendData(CacheCenter:getFriendList())
		end 
	elseif self.m_nCheckIndex == ONLINE_INDEX then
		removeShowPanelNullTip(conFriendList_WndFriends)
		if index~=nil and index > 0 then 
			self:closeLoading()
			local tbconFriend = self:getCurUsingTableContainer()
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
	        		if WndCheckOther.m_root ~= nil then return end 
	        		
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
		local tbconFriend = self:getCurUsingTableContainer()
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
	    self:_updateModel()
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
function WndFriends:setRecommendData(playerId, playerName, level, fighting, headId, faceId, sex, online, vipLevel, headColor, headEffectId, qqHallInfo)
	self:closeLoading()
	if self.m_root == nil then
		return
	end
	if playerId:size() == 0 then
		local tbconFriend = self:getCurUsingTableContainer()
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
		temp.headEffectId = headEffectId and headEffectId:size() > 0 and headEffectId:get(i) or 0
		if qqHallInfo and qqHallInfo:size() > 0 and qqHallInfo:get(i) ~= "" then 
			temp.qqHallData = json.decode(qqHallInfo:get(i))
		end
		table.insert(self.m_tRecommend,temp)
	end
	table.sort(self.m_tRecommend , sortFriends)
--	WZLog("*****22222****", Serialize(self.m_tRecommend))
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
--	WZLog("*****22222****", Serialize(self.m_tRecommend))
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

--@brief 	重新更新置顶好友数据
function WndFriends:resetTopFriends(tNeedTopList)
	--body
	for i,data in pairs(self.m_tFriend) do 
		data.isTop = false
		for k = 1, #tNeedTopList do 
			if tonumber(data.id) == tNeedTopList[k].id then
				data.isTop = true
			end
		end
	end
end

--@brief 	设置邀请好友任务数据
function WndFriends:setInviteTaskData()
	-- body
	WZLog("设置邀请好友任务数据")
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
        self:showFriendsMark(true)
    else
        self:showFriendsMark(false)
    end
	CacheCenter:refreshInviteTask(rewardId, 1)
	WndRewardShow:showById(items, nums)

	--刷新任务
	self:createLoading()
	self.m_nCurPageIndex = 1
    self.m_nCurTag = 0
    self.m_nInviteFriend = 0
	ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList()
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

--@brief 	点击复选框回调
--@param 	tData: 单个好友的数据
--@patam 	nTag : 1->单选；2->全选
function WndFriends:clickCheckBoxCallBack(tCell, tData)
	-- body
	if self.m_tSelFriends == nil then self.m_tSelFriends = {} end

	local chooseNum = tonumber(CacheCenter:getGameParam().chooseNum)

	local bIsHaved = false 
	for i = 1, #self.m_tSelFriends do
		if self.m_tSelFriends[i].id == tData.id then 
			table.remove(self.m_tSelFriends, i)
			bIsHaved = true
			break 
		end
	end
	if not bIsHaved then 
		if chooseNum <= #self.m_tSelFriends then 
			MsgBoxManager:showTipBox(string.format(LocalStrings.FRIEND_DELETE5, chooseNum))
			tCell:setOneCheckboxState(0)
			return 
		end
		table.insert(self.m_tSelFriends, tData)
	end
end

--@brief 	获取筛选的好友是否被选中
function WndFriends:getFriendsSelState(id)
	-- body
	if self.m_tSelFriends == nil or #self.m_tSelFriends == 0 then return 0 end

	for i = 1, #self.m_tSelFriends do
		if self.m_tSelFriends[i].id == id then 
			return 1 
		end
	end
end

function WndFriends:addRemarknameOK(playerId, result, remarkName)
	-- body
	if self.m_root == nil then return end 
	if self.m_nCheckIndex ~= FRIEND_INDEX then return end 

	self:closeLoading()
	WZLog("添加备注"..CellFriends.m_current_click.tag)
	local tbconFriend = self:getCurUsingTableContainer()
	local cellElement = tbconFriend:getCellElement(CellFriends.m_current_click.tag)
	cellElement = WZUIContainer:luaTo(cellElement)
	local cellItem = cellElement:getChildElement("__CellFriends")
	WZLog("WndFriends:addRemarknameOK", type(cellItem))
	local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
	--更新好友的好友度

	local friendId = cellObj:getFriendId()
	local tFriendList = CacheCenter:getFriendList()
	for i = 1, #tFriendList do
		if tFriendList[i].id == friendId then
			cellObj:_showName()
			break
		end
	end
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
		table.sort(self.m_tFriend , funcSortWndFriends)--好友排序
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

function funcSortWndFriends(a,b)
	local onlineA = WndFriends:checkSortOnline(a)
	local onlineB = WndFriends:checkSortOnline(b)
	local relationA = WndFriends:checkSortRelation(a)
	local relationB = WndFriends:checkSortRelation(b)
	local offTimeA = WndFriends:checkOutlineTime(a)
	local offTimeB = WndFriends:checkOutlineTime(b)
	if a.isTop ~= b.isTop then
		return a.isTop
	elseif onlineA ~= onlineB then
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
	if GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):getCheckIndex() == 1 then
		GetElement(self.m_root,"txtNumTitle_WndFriends",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtNum_WndFriends",WZUILabelTTF):setVisible(false)
	end
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
	local conFriendList_WndFriends = GetElement(self.m_root,"tbconFriend_WndFriends",WZUIContainer)
	removeShowPanelNullTip(conFriendList_WndFriends)
	if count > 0 then
		return
	else
        local tbcon = self:getCurUsingTableContainer()
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
	local tbconFriend = self:getCurUsingTableContainer()
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

--@brief 	获取当前使用的列表
function WndFriends:getCurUsingTableContainer()
	-- body
	local tbCon 
	if self.m_nCheckIndex == FRIEND_INDEX then 
		tbCon = GetElement(self.m_root, "tbconFriend_WndFriends", WZUITableContainer)
	else
		tbCon = GetElement(self.m_root, "tbconFriendCD_WndFriends", WZUITableContainer)
	end

	return tbCon
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------好友圈模块Start----------------------------------------
--@brief 	朋友圈数据
function WndFriends:setCircleData(cId, playerId, sex, playerName, vipLevel, headId, faceId, headColor, time, message, verify, comment, spacePhoto, spacePhotoNum, likeTotal, hasLike, likeName, commentTotal, commentId, commentMse, cPlayerId, cPlayerName, bPlayerId, bPlayerName, redDotNum, fPlayerId, fPlayerName, headEffectId, qqHallInfo, setTopMark)
	-- body
	if self.m_root == nil then return end 

	local tTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		self.m_tFriendCircleData = {}
		tTempList = self.m_tFriendCircleData 		
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 
		self.m_tHotCircleData = {} 		
		tTempList = self.m_tHotCircleData 		
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		self.m_tMyCircleData = {}
		tTempList = self.m_tMyCircleData 		
    end
    WZLog("WndFriends:setCircleData", Serialize(hasLike))
    self.m_nNewMessageNum = redDotNum 

	local picIndex = 1 
	local likeIndex = 1
	local commentIndex = 1
	for i = 1, #cId do
		local tCircle = {}
		tCircle.id = cId[i]
		tCircle.playerId = playerId[i]
		tCircle.sex = sex[i]
		tCircle.playerName = playerName[i]
		tCircle.vipLevel = vipLevel[i]
		tCircle.headId = headId[i]
		tCircle.faceId = faceId[i]
		tCircle.headColor = headColor[i]
		tCircle.createTime = time[i]
		tCircle.message = message[i]
		tCircle.picStatus = verify[i]
		tCircle.commentState = comment[i] --陌生人是否可以评论：0开启给陌生人评论 1关闭不让陌生人评论
		tCircle.picNum = spacePhotoNum[i]
		tCircle.headEffectId = headEffectId and headEffectId[i] or 0
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tCircle.qqHallData = json.decode(qqHallInfo[i])
		end
		tCircle.photoUrl = {}
		tCircle.photoStatus = {}
		for k = 1, spacePhotoNum[i] do
			tCircle.photoUrl[k] = spacePhoto[picIndex]
			if tCircle.picStatus == 1 then 
				tCircle.photoStatus[k] = 4
			else
				tCircle.photoStatus[k] = 3
			end

			picIndex = picIndex + 1
		end
		tCircle.goodNum = likeTotal[i]
		tCircle.commentNum = commentTotal[i]
		tCircle.hasLike = hasLike[i]

		--每条朋友圈的点赞数据
		tCircle.goodData = {}
		local goodNameNum = 5
		if tCircle.goodNum < 5 then 
			goodNameNum = tCircle.goodNum
		end
		local tLikeName = {}
		for j = 1, goodNameNum do
			-- tLikeTemp.playerId = like[likeIndex]
			-- tLikeTemp.playerName = likeName[likeIndex]
			-- tLikeTemp.sex = likeSex[likeIndex]
			-- tLikeTemp.vipLevel = likeVip[likeIndex]
			-- tLikeTemp.headId = likeHeadId[likeIndex]
			-- tLikeTemp.faceId = likeFaceId[likeIndex]
			-- tLikeTemp.headColor = likeHeadColor[likeIndex]
			table.insert(tLikeName, likeName[likeIndex])

			likeIndex = likeIndex + 1
		end
		tCircle.goodNameList = tLikeName
		--每条朋友圈的评论数据
		tCircle.commentData = {}
		for j = 1, tCircle.commentNum do
			local tCommentTemp = {}

			tCommentTemp.commentId = commentId[commentIndex]
			tCommentTemp.commentPlayerId = cPlayerId[commentIndex]
			tCommentTemp.commentPlayerName = cPlayerName[commentIndex]
			tCommentTemp.commentMsg = commentMse[commentIndex]
			tCommentTemp.beCommentedPlayerId = bPlayerId[commentIndex]
			tCommentTemp.beCommentedPlayerName = bPlayerName[commentIndex]
			

			table.insert(tCircle.commentData, tCommentTemp)
			commentIndex = commentIndex + 1
		end
		tCircle.setTopMark = setTopMark and setTopMark[i] or 0

		table.insert(tTempList, tCircle)
	end

	self:showCircleList()
end

--@brief 	保存要上传的心情图片数据
function WndFriends:setNeedUploadPhotoData(index, filePath)
	-- body
	if self.m_root == nil then return end 
	if self.m_tAddPhotoData == nil then self.m_tAddPhotoData = {} end
	if self.m_nNeedUploadPhotoNum == nil then self.m_nNeedUploadPhotoNum = 0 end
	local s = {}
	s.objName = ProjConfig:getChannelId().."_"..CacheCenter:getPlayerInfo().id .. "_"..os.time().."_".."circlePhoto"..index..".png"
	s.filePath = filePath
	
	self.m_tAddPhotoData[index] = s
	self.m_nNeedUploadPhotoNum = self.m_nNeedUploadPhotoNum + 1
end

--@brief 	保存要上传的心情图片数据
function WndFriends:deletePhotoData(index)
	-- body
	if self.m_root == nil then return end 
	if self.m_tAddPhotoData == nil then self.m_tAddPhotoData = {} end
	
	self.m_tAddPhotoData[index] = nil 
	self.m_nNeedUploadPhotoNum = self.m_nNeedUploadPhotoNum - 1 
end

--@brief 	判断某格子是否已经上传过照片
function WndFriends:idGridHavePhoto(index)
	-- body
	if self.m_tAddPhotoData and self.m_tAddPhotoData[index] then 
		return true
	else
		return false 
	end
end

--@brief 	1删除心情  2.取消点赞  3.删除评论  4.举报 5.设置心情 6.发布成功  相应处理
function WndFriends:dealWithResultByType(oType, cId, param)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndFriends:dealWithResultByType", oType)
	if oType == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT18)
		self:deleteCircleOK(oType, cId, param)
	elseif oType == 2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT21)
		self:cancelGiveGoodOK(oType, cId, param)
	elseif oType == 3 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT19)
		self:deleteCommentOK(oType, cId, param)
	elseif oType == 4 then 
		WndCircleReport:reportSuccess()
	elseif oType == 5 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT20)
		self:setCommentStateOK(oType, cId, param)
	elseif oType == 6 then 
		if self.m_nCheckIndex == MYCIRCLE_INDEX then 
			MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT16)

			self.m_bIsClickAddCircle = not self.m_bIsClickAddCircle 

    		self:showMyCircle()
    	end
	end
end

--@brief 	获取玩家是否点赞过某一心情
function WndFriends:wetherGiveGood(tCircleData)
	-- body
	return tCircleData.hasLike == 1
end

--@brief 	点赞成功回调
function WndFriends:giveGoodOK(cId, likeTotal, hasLike, likeName)
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT33)
	local tTempList 
    local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 		
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		tTempList[i].hasLike = hasLike
    		tTempList[i].goodNameList = likeName
    		tTempList[i].goodNum = likeTotal
    		WZLog("WndFriends:giveGoodOK", likeTotal, Serialize(likeName))
   --  		local bIsExist = false
   --  		for k = 1, #tTempList[i].goodData do
   --  			if tTempList[i].goodData[k].playerId == like then 
   --  				bIsExist = true
   --  				break 
   --  			end
   --  		end
   --  		if not bIsExist then 

	  --   		local tLikeTemp = {}

			-- 	tLikeTemp.playerId = like
			-- 	tLikeTemp.playerName = likeName
			-- 	tLikeTemp.sex = likeSex
			-- 	tLikeTemp.vipLevel = likeVip
			-- 	tLikeTemp.headId = likeHeadId
			-- 	tLikeTemp.faceId = likeFaceId
			-- 	tLikeTemp.headColor = likeHeadColor

			-- 	table.insert(tTempList[i].goodData, tLikeTemp)
	  --   		tTempList[i].goodNum = tTempList[i].goodNum + 1
			    --更新相应的圈的点赞数据
				local tNewObj, pos = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
				end
				--点赞成功，刷新点赞玩家名字数据
				if tTempList[i].goodNum > 1 then 
					local tCell = self:getHeartTotalObjByIdAndType(cId, 1)
					if tCell then 
						tCell:updateData(tTempList[i])
					end
				else
					local celElement, tCell = CellCircleComment:createElement()
	                if celElement and tCell then 
	                    celElement = WZUIContainer:luaTo(celElement)
	                    tCell:setData(tTempList[i], 1)

	                    flTempList:insert(pos, celElement)
	                end
				end

			-- 	break 
			-- end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	取消点赞成功回调
function WndFriends:cancelGiveGoodOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList 
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)		
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)			
    end
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
			if tTempList[i].hasLike == 1 then 
				tTempList[i].goodNum = tTempList[i].goodNum - 1
				tTempList[i].hasLike = 0
				--移除玩家的名字
				for k = 1, #tTempList[i].goodNameList do
					if tTempList[i].goodNameList[k] == CacheCenter:getPlayerInfo().name then 
						table.remove(tTempList[i].goodNameList, k)
						break 
					end
				end
				--更新相应的圈的点赞数据
				local tNewObj = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
				end
				--点赞数为0时候，移除点赞玩家Cell
				if tTempList[i].goodNum <= 0 then 
					self:deleteHeartTotalObjByIdAndType(cId, 1)
				else
					local tCell = self:getHeartTotalObjByIdAndType(cId, 1)
					if tCell then 
						tCell:updateData(tTempList[i])
					end
				end
				break 
			end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	评论回复成功回调
function WndFriends:commentCircleOK(cId, commentId, commentMse, cPlayerId, cPlayerName, bCommentId, bPlayerId, bPlayerName)
	-- body
	if self.m_root == nil then return end 

	if cId == -1 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT24)
		return 
	elseif cId == -2 then 
		MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT25)
		return
	end

	MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT34)
	local tTempList 
    local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 		
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end

    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		local bIsExist = false
    		for k = 1, #tTempList[i].commentData do
    			if tTempList[i].commentData[k].commentId == commentId then 
    				bIsExist = true
    				break 
    			end
    		end
    		if not bIsExist then 
	    		local tCommentTemp = {}

				tCommentTemp.commentId = commentId
				tCommentTemp.commentPlayerId = cPlayerId
				tCommentTemp.commentPlayerName = cPlayerName
				tCommentTemp.commentMsg = commentMse
				tCommentTemp.beCommentedPlayerId = bPlayerId
				tCommentTemp.beCommentedPlayerName = bPlayerName
				

				table.insert(tTempList[i].commentData, tCommentTemp)
				tTempList[i].commentNum = tTempList[i].commentNum + 1
				--更新相应的圈的评论数据
				local tNewObj, pos = self:getCircleObjById(cId)
				if tNewObj then 
					tNewObj:updateCommentData(tTempList[i])
					--评论成功后，切换回非评论状态，清掉评论框输入
					if bCommentId == 0 then 
						tNewObj:resetCommentInterface()
					else
						local tCellComment = self:getHeartTotalObjByIdAndType(cId, 2, bCommentId)
						if tCellComment then 
							tCellComment:resetCommentInterface()
						end
					end
				end
				--计算新加的评论的位置，加到该心情的最后
				if tTempList[i].goodNum > 0 then 
					pos = pos + 1
				end
				pos = pos + tTempList[i].commentNum - 1
				--重新设置扩展Cell的数据显示
				local tNewObj3, posLast = self:getHeartTotalObjByIdAndType(cId, 3)
				if tNewObj3 then 
					tNewObj3:updateData_type3(tTempList[i])
				end
				if tTempList[i].commentNum <= self.m_nDefaultShowCommentNum then 
					local celElement, tCell = CellCircleComment:createElement()
                    if celElement and tCell then 
                        celElement = WZUIContainer:luaTo(celElement)
                        tCell:setData(tTempList[i], 2, tCommentTemp)
                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                        
                        flTempList:insert(pos, celElement)
                    end
                else
                	--当添加了当前评论，评论数量>3时候，添加查看更多Cell
                	if self.m_tExtendCircle and self.m_tExtendCircle[tostring(cId)] then 
                		local nCurPage, nTotalPage = tNewObj3:getPage()
                		if nCurPage == nTotalPage then 
	                		local celElement, tCell = CellCircleComment:createElement()
		                    if celElement and tCell then 
		                        celElement = WZUIContainer:luaTo(celElement)
		                        tCell:setData(tTempList[i], 2, tCommentTemp)
		                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
		                        
		                        flTempList:insert(posLast - 1, celElement)
		                    end
		                end
                	else
                		--添加可扩展的Cell, 防止重复添加
                		if tTempList[i].commentNum == self.m_nDefaultShowCommentNum + 1 then
                			local conSize = GlobalMethod:CCSize(920, 30)
			                local celElement, tCell = CellCircleComment:createElement(conSize)
			                if celElement and tCell then 
			                    celElement = WZUIContainer:luaTo(celElement)
			                    tCell:setData(tTempList[i], 3)
			                    tCell:setExtendCallBack(self, self.onShowAllComment, self.onShowLess, self.onChangePage)

			                    flTempList:insert(pos, celElement)
			                end
			            end
                	end
				end

				break 
			end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	删除评论成功回调
function WndFriends:deleteCommentOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList 
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)		
    end
    if tTempList == nil then return end 
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		for k = 1, #tTempList[i].commentData do
    			if tTempList[i].commentData[k].commentId == param then 
					table.remove(tTempList[i].commentData, k)
    				tTempList[i].commentNum = tTempList[i].commentNum - 1
    				--更新相应的圈的评论数据
    				local tNewObj = self:getCircleObjById(cId)
    				if tNewObj then 
    					tNewObj:updateCommentData(tTempList[i])
    				end
    				--移除相应的评论
    				self:deleteHeartTotalObjByIdAndType(cId, 2, param)
    				if self.m_tExtendCircle and self.m_tExtendCircle[tostring(cId)] then 
    					--重新设置扩展Cell的数据显示
						local tNewObj3, posLast = self:getHeartTotalObjByIdAndType(cId, 3)
						tNewObj3:updateData_type3(tTempList[i])
						local nCurPage, nTotalPage = tNewObj3:getPage()
						if nCurPage == nTotalPage then 
							if nTotalPage == 1 then 
								if tTempList[i].commentNum == self.m_nDefaultShowCommentNum then 
			    					--移除查看更多的Cell
		    						self:deleteHeartTotalObjByIdAndType(cId, 3)
		    					end
							end
						elseif nCurPage > nTotalPage then --已经将最后一页删除完了
							tNewObj3:setCurPage()
							self:onChangePage(tTempList[i], nTotalPage, nil, nTotalPage)
						else
							--将下一页的第一个添加到当前页最后一个
							local nCommentDataIndex = nCurPage * COMMENT_PERPAGE_NUM
							local tCommentTemp = tTempList[i].commentData[nCommentDataIndex]
							local celElement, tCell = CellCircleComment:createElement()
		                    if celElement and tCell then 
		                        celElement = WZUIContainer:luaTo(celElement)
		                        tCell:setData(tTempList[i], 2, tCommentTemp)
		                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
		                        
		                        flTempList:insert(posLast - 1, celElement)
		                    end
						end
    				else
	    				if tTempList[i].commentNum >= self.m_nDefaultShowCommentNum then 
	    					local tCommentTemp = tTempList[i].commentData[self.m_nDefaultShowCommentNum]

	    					if tCommentTemp then 
	    						local _, pos = self:getHeartTotalObjByIdAndType(cId, 3)
		    					local celElement, tCell = CellCircleComment:createElement()
			                    if celElement and tCell then 
			                        celElement = WZUIContainer:luaTo(celElement)
			                        tCell:setData(tTempList[i], 2, tCommentTemp)
			                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
			                        
			                        flTempList:insert(pos - 1, celElement)
			                    end
			                end
			                if tTempList[i].commentNum == self.m_nDefaultShowCommentNum then 
		    					--移除查看更多的Cell
	    						self:deleteHeartTotalObjByIdAndType(cId, 3)
	    					end
	    				end
	    			end
    				break 
    			end
    		end
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	删除心情成功
function WndFriends:deleteCircleOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList 
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 		
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)		
    end
    if tTempList == nil then return end 
    if flTempList == nil then return end 
    WZLog("WndFriends:deleteCircleOK", #tTempList)

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    for i = 1, #tTempList do
    	WZLog("WndFriends:deleteCircleOK tt", tTempList[i].id, cId)
    	if tTempList[i].id == cId then 
			table.remove(tTempList, i)
			local _, pos = self:getCircleObjById(cId)
			--检测心情往下的COMMENT_PERPAGE_NUM + 4条（评论，点赞，分割线），看看是否属于该朋友圈，属于的话就一并删除
			for k = pos, pos + COMMENT_PERPAGE_NUM + 4 do
				local element = flTempList:getAt(pos-1)   
		        if element then
			        element = WZUIContainer:luaTo(element)
			        local tNewObj = element:getLuaObjectIndex()
			        local id = tNewObj:getCircleId()
			        if id == cId then 
			        	flTempList:removeAt(pos - 1)
			        end
				end
			end
			--移除列表中的心情
			-- self:deleteCircleObjById(cId)
			-- self:deleteCircleLineById(cId)
			--如果列表清空了，更新界面的显示状态
			self:updateInterfaceState(tTempList)
			break 
    	end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief 	根据圈Id获取相应的圈的tCell
function WndFriends:getCircleObjById(circleId)
	-- body
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleOfFriend" then 
	        local id = tNewObj:getCircleId()
	        if id == circleId then 
	        	return tNewObj, i
	        end
	    end
    end

    return nil 
end

--@brief 	根据圈Id和类型获取相应的tCell
--@param 	nType : 1为点赞Cell
--@param 	commentId : 评论Id
function WndFriends:getHeartTotalObjByIdAndType(circleId, nType, commentId)
	-- body
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if tNewObj.getCircleIdAndCommentId then 
	        local id, comId = tNewObj:getCircleIdAndCommentId()
	        local circleType = tNewObj:getType()
	        if nType == 1 or nType == 3 then --点赞
		        if id == circleId and circleType == nType then 
		        	return tNewObj, i
		        end
		    elseif nType == 2 then --评论
		    	if id == circleId and circleType == nType and commentId == comId then 
		        	return tNewObj, i
		        end
		    end
	    end
    end

    return nil 
end

--@brief 	根据圈Id和类型删除相应的tCell
--@param 	nType : 1为点赞Cell
--@param 	commentId : 评论Id
function WndFriends:deleteHeartTotalObjByIdAndType(circleId, nType, commentId)
	-- body
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return nil 
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if tNewObj.getCircleIdAndCommentId then 
	        local id, comId = tNewObj:getCircleIdAndCommentId()
	        local circleType = tNewObj:getType()
	        if nType == 1 or nType == 3 then --点赞
		        if id == circleId and circleType == nType then 
		        	flTempList:removeAt(i - 1)
		        	return i
		        end
		    elseif nType == 2 then --评论
		    	if id == circleId and circleType == nType and commentId == comId then 
		        	flTempList:removeAt(i - 1)
		        	return i
		        end
		    end
	    end
    end

    return nil 
end

--@brief 	根据圈Id删除相应的圈
function WndFriends:deleteCircleObjById(circleId)
	-- body
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleOfFriend" then 
	        local id = tNewObj:getCircleId()
			WZLog("WndFriends:deleteCircleObjById ttt", id, circleId)
	        if id == circleId then 
	        	flTempList:removeAt(i - 1)
	        	return 
	        end
	    end
    end

    return nil 
end

--@brief 	根据圈Id删除相应的分割线
function WndFriends:deleteCircleLineById(circleId)
	-- body
	local flTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)	
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)	
    end
    if flTempList == nil then return end 

    for i = 1, flTempList:size() do
        local element = flTempList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if element:getName() == "__CellCircleBottomLine" then 
	        local id = tNewObj:getCircleId()
			WZLog("WndFriends:deleteCircleLineById ttt", id, circleId)
	        if id == circleId then 
	        	flTempList:removeAt(i - 1)
	        	return 
	        end
	    end
    end

    return nil 
end

--@brief 	移除心情后，判断列表是否为空
function WndFriends:updateInterfaceState(tTempList)
	-- body
	local conMyCircle = GetElement(self.m_root, "conMyCircle_WndFriends", WZUIContainer)
	if tTempList == nil or #tTempList == 0 then 
		if self.m_nCheckIndex == FRIENDCIRCLE_INDEX or self.m_nCheckIndex == HOTCIRCLE_INDEX then 
       		ShowPanelNullTip2(conMyCircle, LocalStrings.FRIENDCIRCLE_TEXT12, nil, nil, GlobalMethod:ccp(0.3, 0), nil)
       	elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
       		GetElement(self.m_root,"conListPanel_WndFriends",WZUIContainer):setVisible(false)
       		ShowPanelNullTip2(conMyCircle, LocalStrings.FRIENDCIRCLE_TEXT11, nil, nil, GlobalMethod:ccp(0.3, 0), nil)
       	end
        return 
    end
end

--@brief 	设置心情是否不允许非好友评论状态成功回调
function WndFriends:setCommentStateOK(oType, cId, param)
	-- body
	if self.m_root == nil then return end 

	local tTempList 
	if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
		tTempList = self.m_tFriendCircleData 		
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 	
		tTempList = self.m_tHotCircleData 		
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
		tTempList = self.m_tMyCircleData 		
    end
    if tTempList == nil then return end 

    for i = 1, #tTempList do
    	if tTempList[i].id == cId then 
    		if tTempList[i].commentState == 0 then 
    			tTempList[i].commentState = 1
    		else
    			tTempList[i].commentState = 0
    		end
    	end
    end
end	

--@brief 	获取未读信息列表成功
function WndFriends:getNewMessageListOK(oType, cId, oMessage, message, bMessage, playerId, playerName, sex, vipLevel, headId, faceId, headColor, headEffectId, qqHallInfo)
	-- body
	if self.m_root == nil then return end 

	self.m_tNewMessageData = {}
	for i = 1, #oType do
		local tItem = {}

		tItem.type = oType[i]
		tItem.circleId = cId[i]
		tItem.topMes = oMessage[i]
		tItem.message = message[i]
		tItem.bMessage = bMessage[i]
		tItem.playerId = playerId[i]
		tItem.playerName = playerName[i]
		tItem.sex = sex[i]
		tItem.vipLevel = vipLevel[i]
		tItem.headId = headId[i]
		tItem.faceId = faceId[i]
		tItem.headColor = headColor[i]
		tItem.headEffectId = headEffectId and headEffectId[i] or 0
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tItem.qqHallData = json.decode(qqHallInfo[i])
		end

		table.insert(self.m_tNewMessageData, tItem)
	end

	WZLog("WndFriends:getNewMessageListOK", Serialize(self.m_tNewMessageData))
	self:showNewMessageList()
end

--@brief 	获取评论的总页数
function WndFriends:getCommentPageNum(tCircleData)
	-- body
	local nTotalPage = math.ceil(tCircleData.commentNum/COMMENT_PERPAGE_NUM)

	return nTotalPage
end

--@brief 	获取选中的标签索引
function WndFriends:getCheckIndex()
	return self.m_nCheckIndex
end

--@brief 	置顶心情回调
function WndFriends:_onCircleSetTopResult(cId)
	if self.m_nCheckIndex == MYCIRCLE_INDEX then 
		for i = 1, #self.m_tMyCircleData do
			if self.m_tMyCircleData[i].id == cId then 
				self.m_tMyCircleData[i].setTopMark = 1
			else
				self.m_tMyCircleData[i].setTopMark = 0
			end
		end
		table.sort(self.m_tMyCircleData, function (a, b)
			-- body
			if a.setTopMark ~= b.setTopMark then 
				return a.setTopMark > b.setTopMark
			else
				return a.createTime > b.createTime
			end
		end)
		
		self:showCircleList()
	end
end
-------------------------------------好友圈模块End----------------------------------------
