--WndCommunityInfo.lua
--@brief	WndCommunityInfo的UI模块
--@date		2013/12/25
--@author	zsq
--@note		公会信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityInfo:onEnter(element)
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
function WndCommunityInfo:onExit(element)
	self:_unInit()
end

function WndCommunityInfo:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCommunityInfo, true)
	end 
end

--@brief	关闭整个窗口时被调用的函数
function WndCommunityInfo:onCloseWindow(element)
	if self.m_root ~= nil then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
		SceneCommunity:_setFindCommunityEditBoxIsTouchEnable(true)
	end 
end 

function WndCommunityInfo:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root, WndCommunityInfo, true)
end

--@brief	点击申请入会按钮函数
function WndCommunityInfo:onClickApplayForMemberShipBtn(element)
	WZLog("WndCommunityInfo:onClickApplayForMemberShipBtn(element)")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local setting = 15
	if GDatatab_button_info ~= nil and GDatatab_button_info["id_9"] ~= nil then
		setting = GDatatab_button_info["id_9"].open_level
	end
	if self.setting ~= nil then
		setting = self.setting
	end
	local vipLevel = self.vipLevel or 0
	--判断入会等级
	if CacheCenter:getPlayerInfo().level < setting then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO231, tostring(setting)))
		return
	end
	--判断入会VIP等级
	if CacheCenter:getPlayerInfo().vipLevel < vipLevel then
		MsgBoxManager:showTipBox(string.format(LocalStrings.COMMUNITYINFO232, tostring(vipLevel)))
		return
	end

	element:setTouchEnable(false)
	local communityId = tonumber(self.m_sCommunityId)
	--申请入会协议
	if communityId ~= nil then
		ProtocolProcessorSceneCommunity:send_GUILD_ApplyGuild(communityId )
	end
end 

--@brief	设置申请入会按钮是否可用
--@param	bEnable:是否可用的标志位
--@note		设置申请入会按钮是否可用
function WndCommunityInfo:setJoinCommunityBtnEnable(bEnable)
	if self.m_root == nil then return end
	local btnApplayForMemberShip = self.m_root:getChildElement("btnApplayForMemberShip_WndCommunityInfo")
	if btnApplayForMemberShip == nil then return end
	btnApplayForMemberShip:setTouchEnable(bEnable)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
--@brief设置公会名称，公会ID,现任会长，公会等级,人数,申请入会在自由列表内容中的函数
function WndCommunityInfo:_setCommunityInfo()
	WZLog(" WndCommunityInfo:_setCommunityInfo()", self.m_nTotemLevel)
	if self.m_root == nil then return end 
	local rank = {LocalStrings.RANK32,LocalStrings.LEAGUE_REPLAY_TEXT9,LocalStrings.LEAGUE_REPLAY_TEXT10,LocalStrings.COMMUNITYINFO143,LocalStrings.COMMUNITYINFO143,LocalStrings.SECOND_PLACE,LocalStrings.COMMUNITYINFO143,LocalStrings.THIRD_PLACE,LocalStrings.SECOND_PLACE,LocalStrings.FIRST_PLACE,LocalStrings.NOT_IN_RANKLIST}
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setText(self.m_sCurrenlyPresident)
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setText(self.m_sTotalNum)
	GetElement(self.m_root,"lv_WndCommunityInfo",WZUILabelTTF):setText(self.m_sCommunityLevel)
	GetElement(self.m_root,"state1_WndCommunityInfo",WZUILabelTTF):setText(self.m_sCommunityDeclare)
	if self.warRank[1] == nil then self.warRank[1] = 11 end
	if self.warRank[2] == nil then self.warRank[2] = 11 end
	if self.warRank[1] == -1 then self.warRank[1] = 11 end
	if self.warRank[2] == -1 then self.warRank[2] = 11 end
	--名字和id
	local temple = [[<T C="79,60,48" S="22" P="1">%s</T><T C="138,122,106" S="22" P="1">(%s)</T>]]
	GetElement(self.m_root,"txtNameId",WZUIFreeTextBox):setShowText(string.format(temple,
	self.m_sCommunityName,tostring(self.m_sCommunityId)))
	--历史最佳排名
	GetElement(self.m_root,"txt21",WZUILabelTTF):setText(rank[self.warRank[1]])
	--上一届排名
	GetElement(self.m_root,"txt23",WZUILabelTTF):setText(rank[self.warRank[2]])

	--图腾等级图片
	local totemLevel = self.m_nTotemLevel%13
	GetElement(self.m_root,"imgTotemLevel",WZUIImage):setFile("ui/community/common_icon_gonghui"..totemLevel..".png")
	GetElement(self.m_root,"imgTotemLevel",WZUIImage):setScale(0.7)
end 

--@brief 	多语言描边字
function WndCommunityInfo:_moreLanguageForStroke()
	if self.m_root == nil  then return end
	--申请入会
	for i=1,3 do 
		local sName = "txtApplyAttendCommunity%d_SceneMyCommunity"
		sName = string.format(sName,i)
		local txtApplyAttendCommunity = self.m_root:getChildElement(sName)
		if txtApplyAttendCommunity then
			txtApplyAttendCommunity = WZUILabelTTF:luaTo(txtApplyAttendCommunity)
			txtApplyAttendCommunity:setText(LocalStrings.APPLY_ATTEND_COMMUNITY)
			txtApplyAttendCommunity:setVisible(true)
		end
    end 
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------语言适配Begin-----------------------------------------------
function WndCommunityInfo:_adaptLanguage_vn(  )
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.71))
	for i=1,3 do 
		local sName = "txtApplyAttendCommunity%d_SceneMyCommunity"
		sName = string.format(sName,i)
		local txtApplyAttendCommunity = self.m_root:getChildElement(sName)
		if txtApplyAttendCommunity then
			txtApplyAttendCommunity = WZUILabelTTF:luaTo(txtApplyAttendCommunity)
			txtApplyAttendCommunity:setScale(0.7)
			txtApplyAttendCommunity:setDimensions(GlobalMethod:CCSize(110,0))
		end
    end
    GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.65)) 
    GetElement(self.m_root,"txt23",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.64,0.492))
    GetElement(self.m_root,"txt21",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.55))
end
function WndCommunityInfo:_adaptLanguage_en(  )
	GetElement(self.m_root,"txt20",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt22",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.71))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.65))
end
function WndCommunityInfo:_adaptLanguage_th(  )
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.71))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.65))
end

function WndCommunityInfo:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txt23",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.492))
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.598,0.71))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.65))
	GetElement(self.m_root,"txt21",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.656189,0.55))
	GetElement(self.m_root,"txt23",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.720013,0.492))
	
end

function WndCommunityInfo:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txt21",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,0.55))
	GetElement(self.m_root,"txt23",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.66,0.492))
	GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.71))
	GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.65))
end

function WndCommunityInfo:_adaptLanguage_es(  )
	local num = GetElement(self.m_root,"num_WndCommunityInfo",WZUILabelTTF)
	num:setRelativePosition(GlobalMethod:ccp(0.6,0.65))
	local chairMan = GetElement(self.m_root,"chairMan_WndCommunityInfo",WZUILabelTTF)
	chairMan:setRelativePosition(GlobalMethod:ccp(0.55,0.71))

	GetElement(self.m_root,"txt20",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txt22",WZUILabelTTF):setFontSize(14)

	local txt21 = GetElement(self.m_root,"txt21",WZUILabelTTF)
	txt21:setFontSize(16)
	txt21:setRelativePosition(GlobalMethod:ccp(0.75,0.55))

	local txt23 = GetElement(self.m_root,"txt23",WZUILabelTTF)
	txt23:setFontSize(14)
	txt23:setRelativePosition(GlobalMethod:ccp(0.8,0.492))
end
------------------------------------------------语言适配End--------------------------------------