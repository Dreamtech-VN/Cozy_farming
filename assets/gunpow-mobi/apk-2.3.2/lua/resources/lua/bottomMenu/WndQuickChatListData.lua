--WndQuickChatListData.lua
--@brief	WndQuickChatList的数据模块
--@date		2021/05/19
--@author	XTX
--@note		快捷发言界面

WndQuickChatList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndQuickChatList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tAllChatList = nil 
	self.m_nSelTab = 1 		
	self.m_nType = 1 					--1->设置;2->战斗
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndQuickChatList:_unInit()
	self.m_root = nil
	self.m_tAllChatList = nil 
	self.m_nSelTab = nil 
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndQuickChatList:createElement()
	if WndQuickChatList.m_root ~= nil then
		WindowManager:removeWindow(WndQuickChatList.m_root, WndQuickChatList, true)
	end
	local element = WZUISystem:getInstance():createElement("WndQuickChatList")
	assert(element, "WndQuickChatList create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndQuickChatList:showInterface(nType, nTab)
	-- body
	local wndQuickChat = WndQuickChatList:createElement()
	if wndQuickChat then 
		self.m_nType = nType or 1
		self.m_nSelTab = nTab or 1
		WindowManager:addWindow(wndQuickChat, WndQuickChatList, true, nil, nil, true)
	end
end

--@brief 	设置数据
function WndQuickChatList:setData()
	-- body
	self.m_tAllChatList = {}
	local tempList = json.decode(CacheCenter:getPlayerInfo().chatShortcut)
	for i, value in pairs(tempList) do
		self.m_tAllChatList[tonumber(i)] = value
	end

	self:_showAllList()
end

--@brief	缓存推送更新玩家基本信息(数据更新)
function WndQuickChatList:updatePlayerInfoData()
	if self.m_root == nil then return end
	if WndBattleHud.m_root then return end 
	self:setData()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
