--WndMarryFriendData.lua
--@brief	WndMarryFriend的数据模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

WndMarryFriend = {
	--请不要在这里定义变量
	
}

GUILD = 2
FRIEND = 1
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryFriend:_init()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_tPopupMenuItems = nil 
	self.m_nCurPageIndex = 1 
	self.m_selectIndex = 0
	self.m_nInterface = 0 
	self.m_tBack = nil 
	self.m_nSelect = 1 
	self.m_bSendGuild = false 
	self.m_nAllSize = 0 
	self.m_nFriendsTableIndex = 0
	self.m_nDisplayedNum = NUMBER_FRIEND_PAGE			--界面显示的最大数量
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_bIsCaculate = true 		--标记数据下标是否需要递增
	self.m_nPageUporDownIndex = 0 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryFriend:_unInit()
	self.m_root = nil
	self.m_tFriend = nil
	self.m_nCurPageIndex = nil 
	self.m_tPopupMenuItems = nil 
	self.m_selectIndex = nil
	self.m_nInterface = nil
	self.m_tBack = nil 
	self.m_bSendGuild = nil
	self.m_nAllSize = 0 
	self.m_nFriendsTableIndex = nil
	self.m_nDisplayedNum = nil
	self.m_nCurNeedLoadNum = nil 			--当前需要加载的数量
	self.m_nCurLoadIndex = nil 				--当前加载的数据下标
	self.m_nCurTag = nil 					--当前加载的Tag
	self.m_bIsCaculate = nil 	
	self.m_nPageUporDownIndex = nil 	--0：不是翻页的时候加载；1：向上翻页；2：向下翻页
end

function WndMarryFriend:receiveFriendListData()
	--屏蔽掉等级不够的好友
	local tTempList = CacheCenter:getFriendDataList()
	nMarryLvLimited = GDatatab_button_info["id_8"].open_level
	WZLog("WndMarryFriend:receiveFriendListData", nMarryLvLimited)
	if nMarryLvLimited == nil then 
		nMarryLvLimited = 21 
	end
	local tFriend = {}
	if self.m_nInterface == 5 then
		for i = 1, #tTempList do
			if tTempList[i].level >= nMarryLvLimited then
				table.insert(tFriend, tTempList[i])
			end
		end

		table.sort(tFriend, sortByFriendliness)
	else
		tFriend = CacheCenter:getFriendDataList()
		table.sort(tFriend, sortFriendMarry)
	end
	self:setFriendData(tFriend)
end

function WndMarryFriend:setFriendData(tFriend)
	if self.m_root == nil then
		return
	elseif tFriend == nil or #tFriend == 0 then
		local desc = LocalStrings.EMPTYFRIENDTIP1
		if self.m_nSelect == 2 then
			desc = LocalStrings.TXT_NOSOCISY_FREND
		end
		self:_showEmptyTip(0,desc)
		return
	end
	for i = 1, #tFriend do
		--status:0->标记未选中；1->标记选中
		tFriend[i].status = 0
	end
	WZLog("****WndMarryFriend:setFriendData*****", Serialize(tFriend)) 
	if self.m_nSelect == 1 then
		self.m_tFriend = tFriend
		self:_update()
		return
	end
	self:_update()
end

function sortFriendMarry(a,b)
	local valueA = WndMarryFriend:checkSortFriends(a)
	local valueB = WndMarryFriend:checkSortFriends(b)
	if valueA ~= valueB then
		return valueA > valueB
	elseif a.level ~= b.level then 
		return a.level >= b.level
	end
end

--@brief 	根据好友度排序
function sortByFriendliness(a, b)
	-- body
	if a.friendliness ~= b.friendliness then
		return a.friendliness > b.friendliness
	else
		return a.level > b.level
	end
end

--@brief 
function WndMarryFriend:checkSortFriends(a)
	-- body
	if a.isOnline == 1 or a.isOnline == true then
		return 2
	else
		return 1
	end
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryFriend:createElement()
	local element = WZUISystem:getInstance():createElement("WndMarryFriend")
	assert(element, "WndMarryFriend create element failed!")
	self:_init()
	WZLog("WndMarryFriend:createElement::")
	return element
end

--@brief	刷新界面
function WndMarryFriend:RefreshInterface()
	
end

--1、发请柬,2、婚礼邀请,3、战斗邀请,4、邮件邀请,5、异性单身
function WndMarryFriend:showInterface(index,tCell,backFun)
	local approval = WndMarryFriend:createElement()
	self.m_nInterface = index 	
	WindowManager:addWindow( approval , WndMarryFriend )
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end	
end

function WndMarryFriend:showFrameA(index)
	local frame = WZUIFrameElement:luaTo(self.m_root:getChildElement("frameA_WndMarryFriend"))
	frame:ShowFrameElement(index)
end

function WndMarryFriend:showFrameB(index)
	local frame = WZUIFrameElement:luaTo(self.m_root:getChildElement("frameB_WndMarryFriend"))
	frame:ShowFrameElement(index)
end

function WndMarryFriend:showMainFrame(index)
	local frame = WZUIFrameElement:luaTo(self.m_root:getChildElement("frameMain_WndMarryFriend"))
	frame:ShowFrameElement(index)
end

--@brief	空数据提示语
function WndMarryFriend:_showEmptyTip(count,desc)
	if count > 0 then
		return
	else
		desc = desc or ""
		local txt = WZUILabelTTF:create()
		txt:setFontSize(30)
		txt:setColor(GlobalMethod:ccc3(138,122,106))
		txt:setText(desc)
		txt:setBoldFont(false)
		txt:setEnableStroke(false)
		txt:setStrokeColor(GlobalMethod:ccc3(255,255,255))
		txt:setStrokeSize(0)
		txt:setTouchEnable(false)
		txt:setTag(0)
		local tbconFriend = self:getCurFrame()
		tbconFriend:cleanTable()
		tbconFriend:setCellElement(txt)
		WZLog("WndMarryFriend:_showEmptyTip::",desc,tbconFriend:getName())

		if ProjConfig.LANGUAGE == "ug" then
			txt:setDimensions(GlobalMethod:CCSize(300))
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------







































