--CellCheckOther2.lua
--@brief	CellCheckOther2的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏2


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther2:onEnter(element)
	self.m_root = element
	self.m_nType = nil					--1:坐骑栏,2:星魂栏,3:祈福
	self.m_tDataList = nil
	self.m_nBtnTag = nil
	self.sureBtnState = "change"
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther2:onExit(element)
	self:_unInit()
	self.m_nType = nil
	self.m_tDataList = nil
	self.m_nBtnTag = nil
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置高亮
function CellCheckOther2:setHighLight(bool)
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	更新标题
function CellCheckOther2:update(i)
	if self.m_root == nil then return end
	local title = {LocalStrings.EQUIPMENT,LocalStrings.DRESS,LocalStrings.CHECKOTHER1,LocalStrings.CHECKOTHER4,LocalStrings.CHECKOTHER4,LocalStrings.CHECKOTHER3,LocalStrings.CHECKOTHER11}
	GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF):setText(title[i])

	GetElement(self.m_root,"conSave",WZUIContainer):setVisible(false)
	if i == 4 then
		GetElement(self.m_root,"conSave",WZUIContainer):setVisible(true)
		if WndCheckOther.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then
			GetElement(self.m_root,"btnSave_CellCheckOther2",WZUIButton):setVisible(true)
		else
			GetElement(self.m_root,"btnSave_CellCheckOther2",WZUIButton):setVisible(false)
		end
	end
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language and (i == 4 or i == 5) then
		GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF):setScale(0.8)
	elseif ("vn" == language or "es" == language) and i == 3 then
		GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0,0.875))
	elseif "th" == language and i == 4 then
		GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF):setScale(0.8)
	elseif ("pt" == language or "es" == language) and (i == 4 or i == 5) then
		local txtTitle = GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF)
		txtTitle:setScale(0.8)
		txtTitle:setRelativePosition(GlobalMethod:ccp(0.013,0.875))
	end
end

--@brief	设置标题
function CellCheckOther2:setTitle(title)
	GetElement(self.m_root,"txtTitle_CellCheckOther2",WZUILabelTTF):setText(title)
end

--@brief	设置签名
function CellCheckOther2:setSignature(signature)
	GetElement(self.m_root,"editSign_CellCheckOther2",WZUIEditBox):setText(signature)
	if signature == LocalStrings.NONE or signature == "" then
		GetElement(self.m_root,"editSign_CellCheckOther2",WZUIEditBox):setText(LocalStrings.BAGTIP1)
	end 
end

--@brief	保存按钮是否可触摸
function CellCheckOther2:_sureBtnTouch(bTouch)
	GetElement(self.m_root,"btnSave_CellCheckOther2",WZUIButton):setTouchEnable(bTouch)
end

--@brief	设置保存按钮上的文字
function CellCheckOther2:setSaveBtnText(txt)
	for i=1,3 do
		local img = GetElement(self.m_root,"imgSave"..i.."_CellCheckOther2",WZUI9Image)
		if txt == LocalStrings.SAVE then
			img:setFile("ui/bag/common_icon_bcz.png")
		else
			img:setFile("ui/bag/common_icon_xf.png")
		end
	end
end

--@brief	保存按钮回调函数
function CellCheckOther2:onSaveClick()
	WZLog("CellCheckOther2保存按钮回调函数")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--按钮是保存状态时的功能
	if self.sureBtnState == "save" then
		--获取签名
		local signature = tostring(GetElement(self.m_root,"editSign_CellCheckOther2",WZUIEditBox):getText())
		self:_sureBtnTouch(true)
		self.sureBtnState = "change"
		self:setSaveBtnText(LocalStrings.CHANGE)
		local playerInfo = CacheCenter:getPlayerInfo()
		playerInfo.signature = signature

		ProtocolProcessorWndBag:send_PLAYER_UpdateContext(signature )
		
		CacheCenter:getPlayerInfo().signature = signature
	else
	--按钮是修改状态时的功能
		local editBox = GetElement(self.m_root,"editSign_CellCheckOther2",WZUIEditBox)
		editBox:openInputKeyBoard()
		self.sureBtnState = "save"
		self:setSaveBtnText(LocalStrings.SAVE)
	end
end
-------------------------------------私有方法模块End----------------------------------------
