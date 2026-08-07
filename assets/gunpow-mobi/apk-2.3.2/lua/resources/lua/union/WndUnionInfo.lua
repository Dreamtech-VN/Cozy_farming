--WndUnionInfo.lua
--@brief	WndUnionInfo的UI模块
--@date		2024/01/09
--@author	XTX
--@note		联盟信息界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUnionInfo:onEnter(element)
	self.m_root = element
	--多语言描边字
	self:_moreLanguageForStroke()
	WindowManagerAni:createAction(element,true)
	--多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUnionInfo:onExit(element)
	self:_unInit()
end

function WndUnionInfo:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndUnionInfo, true)
	end 
end

--@brief	关闭整个窗口时被调用的函数
function WndUnionInfo:onCloseWindow(element)
	if self.m_root ~= nil then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
		WndUnionList:_setFindCommunityEditBoxIsTouchEnable(true)
	end 
end 

function WndUnionInfo:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root, WndUnionInfo, true)
end

--@brief	点击申请入会按钮函数
function WndUnionInfo:onClickApplayForMemberShipBtn(element)
	WZLog("WndUnionInfo:onClickApplayForMemberShipBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local setting = 15
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_230"] ~= nil then
		setting = GDatatab_button_info["id_230"].open_level
	end
	if self.setting ~= nil then
		setting = self.setting
	end
	local vipLevel = self.vipLevel or 0
	--判断入会等级
	if CacheCenter:getPlayerInfo().level < setting then
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[22], tostring(setting)))
		return
	end
	--判断入会VIP等级
	if CacheCenter:getPlayerInfo().vipLevel < vipLevel then
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[23], tostring(vipLevel)))
		return
	end

	if CacheCenter:getPlayerInfo().fighting < self.m_nFighting then 
		MsgBoxManager:showTipBox(string.format(LocalStrings.UNION_TEXT1[39], tostring(self.m_nFighting)))
		return 
	end

	element:setTouchEnable(false)
	local communityId = tonumber(self.m_sCommunityId)
	--申请入会协议
	if communityId ~= nil then
		ProtocolProcessorUnion:send_LEAGUE_ApplyLeague(communityId, self.m_sCommunityName)
	end
end 

--@brief	设置申请入会按钮是否可用
--@param	bEnable:是否可用的标志位
--@note		设置申请入会按钮是否可用
function WndUnionInfo:setJoinCommunityBtnEnable(bEnable)
	if self.m_root == nil then return end
	local btnApplayForMemberShip = self.m_root:getChildElement("btnApplayForMemberShip_WndUnionInfo")
	if btnApplayForMemberShip == nil then return end
	btnApplayForMemberShip:setTouchEnable(bEnable)
end

--@brief 	创建联盟成员列表
function WndUnionInfo:createMenberList()
	local tbMember = GetElement(self.m_root, "tbMember_WndUnionInfo", WZUITableContainer)
	tbMember:cleanTable()

	for i = 1, #self.m_tMemberList do
		local element, tNewObj = CellAlliesItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tMemberList[i])

			tbMember:setCellElement(element)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief设置公会名称，公会ID,现任会长，公会等级,人数,申请入会在自由列表内容中的函数
function WndUnionInfo:_setCommunityInfo()
	WZLog(" WndUnionInfo:_setCommunityInfo()", self.m_nTotemLevel)
	if self.m_root == nil then return end 
	
	GetElement(self.m_root,"chairMan1_WndUnionInfo",WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[12] .. ":")
	GetElement(self.m_root,"chairMan_WndUnionInfo",WZUILabelTTF):setText(self.m_sCurrenlyPresident)
	GetElement(self.m_root,"num_WndUnionInfo",WZUILabelTTF):setText(self.m_sTotalNum)
	GetElement(self.m_root,"lv_WndUnionInfo",WZUILabelTTF):setText(self.m_sCommunityLevel)
	
	--名字和id
	local temple = [[<T C="127,70,26" S="22" P="1">%s</T><T C="127,70,26" S="22" P="1">(%s)</T>]]
	GetElement(self.m_root,"txtNameId_WndUnionInfo",WZUIFreeTextBox):setShowText(string.format(temple,
	self.m_sCommunityName,tostring(self.m_sCommunityId)))
	
	--图腾等级图片
	local totemLevel = self.m_nTotemLevel%13
	GetElement(self.m_root,"imgTotemLevel_WndUnionInfo",WZUIImage):setFile("ui/community/common_icon_gonghui"..totemLevel..".png")
	GetElement(self.m_root,"imgTotemLevel_WndUnionInfo",WZUIImage):setScale(0.7)

	self:createMenberList()
end 

--@brief 	多语言描边字
function WndUnionInfo:_moreLanguageForStroke()
	if self.m_root == nil  then return end
	--申请入会
	for i=1,3 do 
		local sName = "txtApplyAttendCommunity%d_WndUnionInfo"
		sName = string.format(sName,i)
		local txtApplyAttendCommunity = self.m_root:getChildElement(sName)
		if txtApplyAttendCommunity then
			txtApplyAttendCommunity = WZUILabelTTF:luaTo(txtApplyAttendCommunity)
			txtApplyAttendCommunity:setText(LocalStrings.UNION_TEXT1[11])
			txtApplyAttendCommunity:setVisible(true)
		end
    end 
end




-------------------------------------私有方法模块End----------------------------------------

---------------------------------------------语言适配Begin-----------------------------------

function WndUnionInfo:_adaptLanguage_vn(  )
	GetElement(self.m_root, "txtApplyAttendCommunity1_WndUnionInfo", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtApplyAttendCommunity2_WndUnionInfo", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root, "txtApplyAttendCommunity3_WndUnionInfo", WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"chairMan_WndUnionInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.6))
	GetElement(self.m_root,"num_WndUnionInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.37))
	GetElement(self.m_root,"lv_WndUnionInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.14))
end

---------------------------------------------语言适配End--------------------------------------
