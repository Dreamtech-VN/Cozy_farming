--WndOnlineHintFriendData.lua
--@brief	WndOnlineHintFriend的数据模块
--@date		2016/04/29
--@author	Tianxiang_Xu
--@note		好友上线提示列表

WndOnlineHintFriend = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndOnlineHintFriend:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tFriend = nil 		--好友列表
	self.m_nLoadingId = nil 
	self.m_nCurPageIndex = 1 
	self.m_nFriendsTableIndex = 0
	self.m_nDisplayedNum = NUMBER_FRIEND_PAGE			--界面显示的最大数量
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_nPageUporDownIndex = 0 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
	self.m_tNeedRemindFriend = nil 			--需要上线提醒的好友列表	
	self.m_tClickFriendData = nil
	self.m_nType = nil 
	self.m_nNeedFriendness = nil 
	self.m_nHaveSelected = 0 
	self.m_nMaxHave = nil 
	self.m_nLeftNum = nil 		--剩余的密友个数
	self.m_tCallBack = nil 
	self.m_tTopFriend = nil 	--置顶的好友列表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOnlineHintFriend:_unInit()
	self.m_root = nil
	self.m_tFriend = nil 		--好友列表
	self.m_nLoadingId = nil
	self.m_nCurPageIndex = nil
	self.m_nFriendsTableIndex = nil
	self.m_nDisplayedNum = nil			--界面显示的最大数量
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_nPageUporDownIndex = nil 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
	self.m_tNeedRemindFriend = nil 			--需要上线提醒的好友列表
	self.m_tClickFriendData = nil
	self.m_nType = nil 
	self.m_nNeedFriendness = nil 
	self.m_nHaveSelected = nil 
	self.m_nMaxHave = nil 
	self.m_nLeftNum = nil 		--剩余的密友个数
	self.m_tCallBack = nil 
	self.m_tTopFriend = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndOnlineHintFriend:createElement()
	local element = WZUISystem:getInstance():createElement("WndOnlineHintFriend")
	assert(element, "WndOnlineHintFriend element create failed!")
	self:_init()
	return element
end

function WndOnlineHintFriend:receiveFriendListData()
	--屏蔽掉等级不够的好友
	self:closeLoading()
	local tFriend = CacheCenter:getFriendDataList()

	self:setData(tFriend, 2)
end

--@brief 	设置列表数据
--@param 	tDataList : 好友数据列表
--@param 	nType : 类型：1->上线好友提醒；2->添加密友；3->活动张灯结彩-赠礼；4->好友置顶
function WndOnlineHintFriend:setData(tDataList, nType)
	-- body
	if self.m_tNeedRemindFriend == nil then
        self.m_tNeedRemindFriend = {}
    end
    self.m_nType = nType
    if nType == 2 then
    	if tDataList == nil then
    		self:createLoading()
    		ProtocolProcessorWndFriends:send_FRIEND_GetFriend(10, 1)
    		return 
    	end
    	self.m_nNeedFriendness = tonumber(CacheCenter:getGameParam()["chumFriendNum"])
    	self.m_nMaxHave = tonumber(CacheCenter:getGameParam()["maxChum"])
    	self.m_nLeftNum = self.m_nMaxHave - CacheCenter:getBestFriendNum() 
    end
    
	if tDataList == nil or #tDataList == 0 then
		local conForList = GetElement(self.m_root, "conForList_WndOnlineHintFriend", WZUIContainer)
		self:_setStaticText()
		ShowPanelNullTip( conForList, LocalStrings.EMPTYFRIENDTIP1)
		return 
	end
	self.m_tFriend = tDataList
	self.m_tFriendOld = CopyTable(tDataList)
	if self.m_nType == 1 then
		table.sort(self.m_tFriend, sortList)
	    for i = 1, #self.m_tFriend do
	    	if self.m_tFriend[i].isOnlineRemind == 1 or self.m_tFriend[i].isOnlineRemind == true then
	    		WZLog("WndOnlineHintFriend:setData", self.m_tFriend[i].id)
	    		table.insert(self.m_tNeedRemindFriend, self.m_tFriend[i])
	    	end
	    end
	elseif self.m_nType == 2 then
		self.m_tFriend = CopyTable(self.m_tFriend)
        for i = 1, #self.m_tFriend do
            self.m_tFriend[i].isAddForBest = false
        end
		table.sort(self.m_tFriend, sortFriends)
	elseif self.m_nType == 3 then 
		self.m_nLeftNum = WndDecorations.m_tContent.sendCardLeftNum
	elseif self.m_nType == 4 then
		table.sort(self.m_tFriend, function (a,b)
			if a.isTop ~= b.isTop then
				return a.isTop
			elseif a.friendliness ~= b.friendliness then
				return a.friendliness > b.friendliness
			elseif a.level ~= b.level then
				return a.level > b.level
			else
				return a.id < b.id
			end
		end)
		for i = 1, #self.m_tFriend do
			if self.m_tFriend[i].isTop == true then
				table.insert(self.m_tNeedRemindFriend, self.m_tFriend[i])
			end
		end
	end
	
	self:_update()
end

--@brief 	排序函数
function sortList(a, b)
	-- body
	if a.friendliness ~= b.friendliness then
		return a.friendliness > b.friendliness
	else
		if a.level ~= b.level then
			return a.level > b.level
		else
			return a.id < b.id 
		end
	end
end

--@brief 	设置点击确定回调函数
function WndOnlineHintFriend:setCallBackFunc(tCell, func1)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func1
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
