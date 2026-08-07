--WndDoubleSevenInvitData.lua
--@brief	WndDoubleSevenInvit的数据模块
--@date		2020/08/04
--@author	hyx
--@note		邀请界面

WndDoubleSevenInvit = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleSevenInvit:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = 1
	self.m_tInvateItem = {}
	self.m_tInvateFriends = {} --邀请好友的请求列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleSevenInvit:_unInit()
	self.m_root = nil
	self.m_nCurIndex = 1
	self.m_tInvateItem = {}
	self.m_tInvateFriends = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleSevenInvit:createElement()
	if WndDoubleSevenInvit.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleSevenInvit.m_root, WndDoubleSevenInvit, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleSevenInvit")
	assert(element, "WndDoubleSevenInvit create element failed!")
	self:_init()
	return element
end

--************* 选择好友 ****************
CellChooseFriendsItem = {}
function CellChooseFriendsItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChooseFriendsItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellChooseFriendsItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellChooseFriendsItem:setChooseFriendsMessage(index, data)
	self.m_nChooseIndex = index
	self.m_tFreindsData = data
end
function CellChooseFriendsItem:setChooseFriendsCallFun(callback)
	self.m_sChooseFriendsCallBack = callback
end
--@brief 	开始加载
function CellChooseFriendsItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellChooseItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upInviteFriendDateItem()
end

function CellChooseFriendsItem:upInviteFriendDateItem()
	self.checkBoxChooseFriend = GetElement(self.m_root,"checkBoxChooseFriend",WZUICheckBox)

	local choose_level = GetElement(self.m_root,"choose_level",WZUILabelTTF)
	choose_level:setText(self.m_tFreindsData.level)
	local choose_name = GetElement(self.m_root,"choose_name",WZUILabelTTF)
	choose_name:setText(self.m_tFreindsData.playerName)
	if self.m_tFreindsData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
		GetElement(self.m_root, "imgKuafu_CellChooseItem", WZUIImage):setVisible(true)
		choose_name:setRelativePosition(GlobalMethod:ccp(0.185, 0.621))
	end
	SetQQHallBlueIcon(self.m_root, self.m_tFreindsData.qqHallData, {"imgBluePri_CellChooseFriendsItem", "imgBlueYear_CellChooseFriendsItem"}, {"choose_name", "imgKuafu_CellChooseItem"}, {WZUILabelTTF, WZUIImage}, 0.03)

	local head_container = GetElement(self.m_root,"head_container",WZUIContainer)
	CellHead:show(head_container, self.m_tFreindsData.headItemId, self.m_tFreindsData.faceItemId, self.m_tFreindsData.sex, false, nil, nil, self.m_tFreindsData.colour, nil, nil, nil, nil, self.m_tFreindsData.headEffectId)
end

function CellChooseFriendsItem:onClickHead()
	if not self.m_tFreindsData then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tFreindsData.playerId)
end

function CellChooseFriendsItem:onClickChoose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_sChooseFriendsCallBack then
		local status =  self.checkBoxChooseFriend:getCheckIndex()
		self.m_sChooseFriendsCallBack(self.m_nChooseIndex, status, self.m_tFreindsData.playerId)
	end
end
--@return	新建的表实例对象
function CellChooseFriendsItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--*****************************

--************* 邀请通知 1 ***************
CellInvateNoticeItem1 = {}
function CellInvateNoticeItem1:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellInvateNoticeItem1:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellInvateNoticeItem1:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellInvateNoticeItem1:setNotice1InitMessage(tData)
	self.tNotice1Data = tData
end
--@brief 	开始加载
function CellInvateNoticeItem1:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellNoticeItem1")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upNotice1DateItem()
end

function CellInvateNoticeItem1:upNotice1DateItem()
	if not self.tNotice1Data then return end

	local head_container = GetElement(self.m_root,"head_container",WZUIContainer)
	CellHead:show(head_container, self.tNotice1Data.headId, self.tNotice1Data.faceId, self.tNotice1Data.sex, false, nil, nil, self.tNotice1Data.headColor)

	local name_freetext = GetElement(self.m_root,"name_freetext",WZUIFreeTextBox)
	local str = string.format([[<T C="127,70,26" S="20" P="1">Lv.</T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> %s</T>]],self.tNotice1Data.level,self.tNotice1Data.nickname)
	name_freetext:setShowText(str)
	local notice_tips = GetElement(self.m_root,"notice_tips",WZUILabelTTF)
	notice_tips:setText(self.tNotice1Data.desc)
	
	local is_bind = WndDoubleSeven:getBindFriend()
	local btnRefuse = GetElement(self.m_root,"btnRefuse",WZUIButton)
	local refuse_label = GetElement(btnRefuse,"refuse_label",WZUILabelTTF)
	refuse_label:setText(LocalStrings.REJECT)

	local btnAgree = GetElement(self.m_root,"btnAgree",WZUIButton)
	local agree_label = GetElement(btnAgree,"agree_label",WZUILabelTTF)
	agree_label:setText(LocalStrings.AGREE)
	if is_bind ~= 0 then
		btnRefuse:setTouchEnable(false)
		btnAgree:setTouchEnable(false)
		refuse_label:setColor(GlobalMethod:ccc3(255,255,255))
		refuse_label:setStrokeColor(GlobalMethod:ccc3(80,61,50))

		agree_label:setColor(GlobalMethod:ccc3(255,255,255))
		agree_label:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	end
end
--拒绝
function CellInvateNoticeItem1:onBtnClickRefuse()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.tNotice1Data and self.tNotice1Data.playerId then
		ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess(3, TableToVector({self.tNotice1Data.playerId}, WZLuaVector_int_) )
	end
end
--同意
function CellInvateNoticeItem1:onBtnClickAgree()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.tNotice1Data and self.tNotice1Data.playerId then
		ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess(2, TableToVector({self.tNotice1Data.playerId}, WZLuaVector_int_) )
	end
end

function CellInvateNoticeItem1:onClickHead()
	if not self.tNotice1Data then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.tNotice1Data.playerId)
end

--@return	新建的表实例对象
function CellInvateNoticeItem1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--****************************
--************* 邀请通知 2 ***************
CellInvateNoticeItem2 = {}
function CellInvateNoticeItem2:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellInvateNoticeItem2:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellInvateNoticeItem2:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellInvateNoticeItem2:setNotice2InitMessage(tData)
	self.tNotice2Data = tData
end
--@brief 	开始加载
function CellInvateNoticeItem2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellNoticeItem2")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upNotice2DateItem()
end

function CellInvateNoticeItem2:upNotice2DateItem()
	if not self.tNotice2Data then return end

	local refuse_freetext = GetElement(self.m_root,"refuse_freetext",WZUIFreeTextBox)
	local str = LocalStrings.DOUBLE_SEVEN_TEXT25
	if self.tNotice2Data.confessStatus == 1 then --接受的时候
		str = LocalStrings.DOUBLE_SEVEN_TEXT33
	end
	refuse_freetext:setShowText(string.format(str, self.tNotice2Data.nickname))
end

--@return	新建的表实例对象
function CellInvateNoticeItem2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
--****************************
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
