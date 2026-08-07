--CellHouseInviteFriendData.lua
--@brief	CellHouseInviteFriend的数据模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面

CellHouseInviteFriend = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellHouseInviteFriend:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFriendItem = {}
	self.m_tChoosePlsyerId = {}
	self.m_tFriendInvestData = {}
	self.m_nInviteState = -1 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellHouseInviteFriend:_unInit()
	self.m_root = nil
	self.m_tFriendItem = {}
	self.m_tChoosePlsyerId = {}
	self.m_tFriendInvestData = {}
	self.m_nInviteState = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellHouseInviteFriend:createElement()
	if CellHouseInviteFriend.m_root ~= nil then
		WindowManager:removeWindow(CellHouseInviteFriend.m_root, CellHouseInviteFriend, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellHouseInviteFriend")
	assert(element, "CellHouseInviteFriend create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end


-- 好友数据
function CellHouseInviteFriend:setInviteData(tData)
	local tFriends = CacheCenter:getCurrentFriendList()
	local tTempInviteFriends = {}
	WZLog("CellHouseInviteFriend:setInviteData", Serialize(tData.ids), Serialize(tData.status))
	for i = 1, #tData.ids do
		for j = 1, #tFriends do
			if tFriends[j].id == tData.ids[i] and tData.status[i] ~= 1 then 
				local tItem = {}
				tItem.id = tFriends[j].id
				tItem.name = tFriends[j].name
				tItem.level = tFriends[j].level
				tItem.sex = tFriends[j].sex
				tItem.faceId = tFriends[j].faceItemId
				tItem.headId = tFriends[j].headItemId
		        tItem.vipLevel = tFriends[j].vipLevel
		        tItem.serverId = tFriends[j].serverId
		        tItem.headColor = tFriends[j].headColor
				tItem.inviteState = tData.status[i]
				tItem.playerId = tItem.id
				tItem.winType = self.m_nWinType or 1
				table.insert(tTempInviteFriends, tItem)
				break
			end
		end
	end
	return tTempInviteFriends
end

--@brief 	设置窗口类型
function CellHouseInviteFriend:setWinType(nWinType)
	self.m_nWinType = nWinType or 1
end

function CellHouseInviteFriend:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--======= 邀请好友 ========
FriendItem = {}
function FriendItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function FriendItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function FriendItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function FriendItem:setNoticeData(data, func)
	self.m_tNoticeData = data
	self.m_sNoticeFunc = func
end

--@brief 	开始加载
function FriendItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("FriendItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function FriendItem:setData()
	if not self.m_tNoticeData then return end

	if self.m_tNoticeData.winType and self.m_tNoticeData.winType == 6 then 
		GetElement(self.m_root, "img9Bg_FriendItem", WZUI9Image):setFile("ui/common/frame_lieb_03.png")
	end
	self:setChooseApplyVisible(self.m_tNoticeData.inviteState)
	local txtName = GetElement(self.m_root,"txtName",WZUIFreeTextBox)
	if self.m_tNoticeData.serverId == CacheCenter:getPlayerInfo().serverId then
		txtName:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]],self.m_tNoticeData.name))
	else
		txtName:setShowText(string.format([[<I Z="1">ui/common/common_icon_kuafu.png</I><T C="127,70,26" S="20" P="1">%s</T>]],self.m_tNoticeData.name))
	end
	GetElement(self.m_root,"txtLevel",WZUILabelTTF):setText(self.m_tNoticeData.level)
	local head_contianer = GetElement(self.m_root,"head_contianer",WZUIContainer)
	CellHead:show(head_contianer, self.m_tNoticeData.headId, self.m_tNoticeData.faceId, self.m_tNoticeData.sex, false, nil, self.m_tNoticeData.vipLevel, self.m_tNoticeData.headColor)
end

function FriendItem:onClickRankHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tNoticeData then return end
	WndCheckOther:show(self.m_tNoticeData.playerId)
end
function FriendItem:setChooseApplyVisible(state)
	if not self.m_root then return end
	
	local btnChoose = GetElement(self.m_root,"btnChoose",WZUIButton)
	btnChoose:setVisible(false)
	local txtApply = GetElement(self.m_root,"txtApply",WZUILabelTTF)
	txtApply:setVisible(false)
	if state == 2 then
		txtApply:setVisible(true)
	else
		btnChoose:setVisible(true)
	end
end
--选择的
function FriendItem:onBtnChoose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tNoticeData then return end
	if self.m_sNoticeFunc then
		self.m_sNoticeFunc(self.m_tNoticeData.playerId)
	end
end
function FriendItem:setSelectPlayer(visible)
	if not self.m_root then return end
	GetElement(self.m_root,"imgSelect",WZUIImage):setVisible(visible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function FriendItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end





-------------------------------------私有方法模块End----------------------------------------
