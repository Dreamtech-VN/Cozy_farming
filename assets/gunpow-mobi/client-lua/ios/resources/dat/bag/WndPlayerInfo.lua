--WndPlayerInfo.lua
--@brief	WndPlayerInfo的UI模块
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPlayerInfo:onEnter(element)
	self.m_root = element
end

function WndPlayerInfo:onEnterTransitionDidFinish(element)
	AdaptLanguage(self)
	ProtocolProcessorWndBag:regAll()
	self:_moreLanguage()
	self:_setUIStaticText()
	self:_setSupportMultiChar(false)

	self.sureBtnState = "change"
	self:setSaveBtnText(LocalStrings.CHANGE)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPlayerInfo:onExit(element)
    WZLog("WndPlayerInfo:onExit")
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
    Teach:isStartTeach("WndPlayerInfo:onExit")
end

function WndPlayerInfo:onClose()
	if self.m_root == nil then
		return
	end
	ProtocolProcessorWndBag:unregAll()
	self.m_root:removeFromParentAndCleanup(true)
	self.m_root = nil
end

--@brief	设置高亮
function WndPlayerInfo:setHighLight(bool)
	WZLog("WndPlayerInfo:setHighLight")
    if self.m_root == nil then return end
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	编辑结束返回回调函数
function WndPlayerInfo:onReturn(element)
	WZLog("WndPlayerInfo:onReturn(element)::")
	checkEditLenovoWord(element)
end

--@brief	设置改变回调函数
function WndPlayerInfo:onChangeSignature(element)
	WZLog("WndPlayerInfo:onChangeSignature")
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
	for k,v in pairs(ChatKeyWords) do
		txt = string.gsub(txt,v,"")
	end
	element:setText(txt)
	if self.m_tPlayer then
		if txt ~= self.m_tPlayer.signature then
			self:_sureBtnTouch(true)
			self.sureBtnState = "save"
			self:setSaveBtnText(LocalStrings.SAVE)
		end
	end
end

--@brief	设置保存按钮上的文字
function WndPlayerInfo:setSaveBtnText(txt)
	for i=1,3 do
		local img = GetElement(self.m_root,"imgSave"..i.."_WndPlayerInfo",WZUI9Image)
		if txt == LocalStrings.SAVE then
			img:setFile("ui/bag/common_icon_bcz.png")
		else
			img:setFile("ui/bag/common_icon_xf.png")
		end
	end
end

--@brief	保存按钮回调函数
function WndPlayerInfo:onSaveClick()
	WZLog("WndPlayerInfo保存按钮回调函数::")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--按钮是保存状态时的功能
	if self.sureBtnState == "save" then
		local signature = tostring(self:_getSignature())--获取签名
		self:_sureBtnTouch(true)
		self.sureBtnState = "change"
		self:setSaveBtnText(LocalStrings.CHANGE)

		WndPlayerInfo:createLoading()
		ProtocolProcessorWndBag:send_PLAYER_UpdateContext(signature )
	else
	--按钮是修改状态时的功能
		local editBox = GetElement(self.m_root,"editSign_WndPlayerInfo",WZUIEditBox)
		editBox:openInputKeyBoard()
		self.sureBtnState = "save"
		self:setSaveBtnText(LocalStrings.SAVE)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	vip按钮被点击
function WndPlayerInfo:onVipClick(element)
	WZLog("WndPlayerInfo:onVipClick")
end

--@brief	tip按钮被点击
function WndPlayerInfo:onTipClick(element)
	WZLog("WndPlayerInfo:onTipClick")
	local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conRightB_WndBag"))
	WndItemInfo:showInfo(element,parent,3,"玩家属性值",false,ccp(-180,5))
end

--@brief   更新更新签名
function WndPlayerInfo:_updateSignature()
	WZLog("WndPlayerInfo:_updateSignature")
	if self.m_root == nil or self.m_tPlayer == nil then
		return
	end
	self:_setID(self.m_tPlayer.id)--ID

	self:_setSignature(self.m_tPlayer.signature)--签名
end

--ID
function WndPlayerInfo:_setID(id)
	if id == "" then
		id = LocalStrings.NONE
	end
	GetElement(self.m_root,"freeTxtID_WndPlayerInfo",WZUILabelTTF):setText(id)
end

--@brief	签名
function WndPlayerInfo:_setSignature(txt)
	if self.m_root == nil then return end
	local editSignature = self.m_root:getChildElement("editSign_WndPlayerInfo")
	editSignature = WZUIEditBox:luaTo(editSignature)
	if txt == nil or txt == "" then
		editSignature:setPlaceHolder(LocalStrings.BAGTIP1)
		return
	end
	editSignature:setText(txt)
	--editSignature:setText("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十")
	editSignature:setTouchEnable(true)
end

--@brief	保存按钮是否可触摸
function WndPlayerInfo:_sureBtnTouch(bTouch)
	if self.m_root == nil then return end
	local btnSure = self.m_root:getChildElement("btnSave_WndPlayerInfo")
	if btnSure then
		btnSure = WZUIButton:luaTo(btnSure)
		btnSure:setTouchEnable(bTouch)
	end
end

--@brief	设置签名是否可以触摸（设置固定不能触摸）
function WndPlayerInfo:_setSignatureTouch(bTouch)
	if self.m_root == nil then return end
	local bTouch = false
	local editSignature = self.m_root:getChildElement("editSign_WndPlayerInfo")
	WZUIEditBox:luaTo(editSignature):setTouchEnable(false)
end

--@brief	获取签名
function WndPlayerInfo:_getSignature()
	if self.m_root == nil then return end
	local editSignature = self.m_root:getChildElement("editSign_WndPlayerInfo")
	return WZUIEditBox:luaTo(editSignature):getText()
end

--@brief   不显示编辑签名
function WndPlayerInfo:showEditSgin(bShow)
	if self.m_root == nil then return end
	local sgin = WZUIEditBox:luaTo(self.m_root:getChildElement("editSign_WndPlayerInfo"))
	sgin:setVisible(bShow)
end

--@brief   创建加载框
function WndPlayerInfo:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndPlayerInfo:closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

--@brief	查看属性介绍
function WndPlayerInfo:onAttr(element)
	WZLog("WndPlayerInfo:onAttr")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	local tData = {icon="",
		attrInfo1=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
		attrInfo2=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
		attrInfo3=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
		attrInfo4=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
		attrInfo5=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
		attrInfo6=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
		attrInfo7=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
		attrInfo8=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
		attrInfo9=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
		attrInfo10=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
		attrInfo11=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
		attrInfo12=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
		attrInfo13=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
		}
	if ProjConfig.LANGUAGE == "vn" then
		tData = {icon="",
		attrInfo1=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
		attrInfo2=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
		attrInfo3=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
		attrInfo4=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
		attrInfo5=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
		attrInfo6=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
		attrInfo7=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
		attrInfo8=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
		attrInfo9=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
		attrInfo10=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
		attrInfo11=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
		attrInfo12=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
		attrInfo13=string.format([[<T C="255,227,116" S="16" P="0">%s:</T><T C="255,236,193" S="16" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
		}
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
		tData = {icon="",
		attrInfo1=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
		attrInfo2=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
		attrInfo3=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
		attrInfo4=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
		attrInfo5=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
		attrInfo6=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
		attrInfo7=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
		attrInfo8=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
		attrInfo9=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
		attrInfo10=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
		attrInfo11=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
		attrInfo12=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
		attrInfo13=string.format([[<T C="255,227,116" S="18" P="0">%s:</T><T C="255,236,193" S="18" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
		}
	elseif ProjConfig.LANGUAGE == "th"  then
		tData = {icon="",
			attrInfo1=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
			attrInfo2=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
			attrInfo3=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
			attrInfo4=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
			attrInfo5=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
			attrInfo6=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
			attrInfo7=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
			attrInfo8=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
			attrInfo9=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
			attrInfo10=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
			attrInfo11=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
			attrInfo12=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
			attrInfo13=string.format([[<T C="255,227,116" S="20" P="0">%s:</T><T C="255,236,193" S="20" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
		}
	elseif ProjConfig.LANGUAGE == "es" then
		tData = {icon="",
		attrInfo1=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
		attrInfo2=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
		attrInfo3=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
		attrInfo4=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
		attrInfo5=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
		attrInfo6=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
		attrInfo7=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
		attrInfo8=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
		attrInfo9=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
		attrInfo10=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
		attrInfo11=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
		attrInfo12=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
		attrInfo13=string.format([[<T C="255,227,116" S="12" P="0">%s:</T><T C="255,236,193" S="12" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
		}
	end
	
	WndTips:show(element,self.m_root,2,tData)
end

--@brief	竞技   tip
function WndPlayerInfo:onTip1(element)
	WZLog("WndPlayerInfo:onTip1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 1
	local tData = self.m_tPlayer
	local playNum = tData.playNum
	tData.highLightObj = self
	if playNum == 0 and tData.level < 8 then
		local title = LocalStrings.TIPS3
		local tData = {icon="ui/common/common_icon_hz2.png",
			title=title,
			level=nil,
			px=0.2,
			py=0.5,
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		WndTips:show(element,self.m_root,4,tData,GlobalMethod:ccp(25,10))
	end
end

--@brief	排位等级
function WndPlayerInfo:onTip2(element)
	WZLog("WndPlayerInfo:onTip2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 2
	local level = CacheCenter:getPlayerInfo().segmentLevel
	if tonumber(level) == 0 then
		local title = LocalStrings.TIPS4
		local tData = {icon="ui/common/common_icon_pws1.png",
			title=title,
			level=level,
			px=0.2,
			py=0.5,
			highLightObj = self,
			pvprankMark = 1,
			}
		WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
    	local info = json.decode(CacheCenter:getPlayerInfo().rankMatchMessage)
    	local data = {level = tonumber(info.level), winNum = info.winTimes,total = info.joinTimes,maxWinNum = info.continous,exp = tonumber(info.exp)}
    	WndTips:show(element,self.m_root,17,data,GlobalMethod:ccp(36,-5))
	end
end

--@brief	图腾等级
function WndPlayerInfo:onTip3(element)
	WZLog("WndPlayerInfo:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 3
	local level = CacheCenter:getPlayerInfo().totemLevel
	WZLog("CellCheckOther1:onTip3",level)
	local title
	local icon = "ui/community/common_icon_gonghui"..level..".png"
	if tostring(level) == "0" then
		title = LocalStrings.TIPS5
		local tData = {icon=icon,
			title=title,
			level=nil,
			scale=0.5,
			scale=0.5,
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
	else
		local totemInfo = GDatatab_guild_totem["id_"..level]
		local property = totemInfo.property
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.TIPS6
		local guildName = CacheCenter:getPlayerInfo().guildName
		local position = COMMUNITY_POSITION[CacheCenter:getPlayerInfo().position+1]

		local attr = {}
		local attrVal = {}
		for i=1,#property do
			attr[i] = ATTR_TITLE[property[i][1]]
			attrVal[i] = property[i][2]
		end

		local tData = {icon=icon,
			title1=title1,
			guildName=guildName,
			level=level,
			scale=0.5,
			position=position,
			attr1=attr[1],
			attr2=attr[2],
			attr3=attr[3],
			attrVal1=attrVal[1],
			attrVal2=attrVal[2],
			attrVal3=attrVal[3],
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,21,tData,ccp(-55,0))
	end 
end

--@brief	恩爱等级
function WndPlayerInfo:onTip4(element)
	WZLog("WndPlayerInfo:onTip4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 4
	local level = CacheCenter:getPlayerInfo().loveLevel
	local sex = CacheCenter:getPlayerInfo().sex
	local mateName = CacheCenter:getPlayerInfo().mateName
	local icon = "ui/common/common_icon_enai1.png"
	if tonumber(CacheCenter:getPlayerInfo().marryFlag) == 0 then 
		local tData = {icon=icon,
			title=LocalStrings.TIPS7,
			level=nil,
			px=0.2,
			py=0.5,
			scale=0.5,
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
	elseif tonumber(CacheCenter:getPlayerInfo().marryFlag) == 1 then
		local tData = {icon=icon,
			title=string.format([[<T C="158,139,121" S="20" P="0">%s</T>]],LocalStrings.BAGTIP2),
			level=nil,
			px=0.2,
			py=0.5,
			scale=0.5,
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
	elseif tonumber(CacheCenter:getPlayerInfo().marryFlag) == 2 then
		local tBuff_id = json.decode(CacheCenter:getPlayerInfo().loveSkill)
		local attrNum = 1
		local title1 = level..LocalStrings.LEVEL1..LocalStrings.LOVING_LEVEL
		local attr = {}
		local attrVal = {}
		for k,v in pairs(tBuff_id) do
			local buff_id = v
			local effect_id = GDatatab_buff["id_"..buff_id].effect_id
			local effect = GDatatab_effect["id_"..effect_id].effect
			attr[attrNum] = ATTR_TITLE[effect[1][5]]
			attrVal[attrNum] = effect[1][6]
			attrNum = attrNum + 1
		end
		local tData = {icon=icon,
			title1=title1,
			mateName=mateName,
			scale=0.5,
			attr1=attr[1],
			attr2=attr[2],
			attr3=attr[3],
			attrVal1=attrVal[1],
			attrVal2=attrVal[2],
			attrVal3=attrVal[3],
			level=level,
			highLightObj = self,
			}
		WndTips:show(element,self.m_root,22,tData,ccp(-45,0))
	end
end

--@brief	师德等级
function WndPlayerInfo:onTip5(element)
	WZLog("WndPlayerInfo:onTip5")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 5
	local level = CacheCenter:getPlayerInfo().moralityLevel
	local masterName = CacheCenter:getPlayerInfo().masterName
	local roleLevel = CacheCenter:getPlayerInfo().level
	local icon
	local quality = -1
	local title
	local title1 = ""
	local title2 = ""
	local attr1
	local attr2
	local attr3
	local attrVal1
	local attrVal2
	local attrVal3
	local scale = 0.5
	
	local tData
	if roleLevel >= MASTERLEVEL then
		icon = "ui/bag/bag_icon_shitu.png"
		title1 = string.format(LocalStrings.RANK_KING_DESC11,level)

		if tostring(level) ~= "0" then
			local tNovice = json.decode(masterName)
			tData = GDatatab_morality["id_"..level]
			title = LocalStrings.RANK_KING_DESC10
			title2 = tNovice
			attr1 = ATTR_TITLE[tData.buff[1][1]]
			attr2 = ATTR_TITLE[tData.buff[2][1]]
			attr3 = ATTR_TITLE[tData.buff[3][1]]
			attrVal1 = tData.buff[1][2]
			attrVal2 = tData.buff[2][2]
			attrVal3 = tData.buff[3][2]
		else
			title = LocalStrings.TIPS9
			local tData = {icon=icon,
				title=title,
				level=nil,
				scale=scale,
				highLightObj = self,
				}
			WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
			return
		end
	else
		icon = "ui/common/common_icon_shidei.png"
		if tostring(level) == "0" then
			title = LocalStrings.TIPS8
			local tData = {icon=icon,
				title=title,
				scale=scale,
				highLightObj = self,
				}
			WndTips:show(element,self.m_root,1,tData,GlobalMethod:ccp(30,0))
			return
		else
			local tNovice = json.decode(masterName)
			tData = GDatatab_morality["id_"..level]
			title = LocalStrings.RANK_KING_DESC9
			title1 = level..LocalStrings.LEVEL1..LocalStrings.RANK_KING_DESC12
			title2 = tNovice
			attr1 = ATTR_TITLE[tData.pupil_buff[1][1]]
			attr2 = ATTR_TITLE[tData.pupil_buff[2][1]]
			attr3 = ATTR_TITLE[tData.pupil_buff[3][1]]
			attrVal1 = tData.pupil_buff[1][2]
			attrVal2 = tData.pupil_buff[2][2]
			attrVal3 = tData.pupil_buff[3][2]
			level = nil
		end
	end
	if roleLevel < MASTERLEVEL then level = nil end
	local tData = {icon=icon,
		title=title,
		title1=title1,
		title2=title2,
		quality=quality,
		attr1=attr1,
		attr2=attr2,
		attr3=attr3,
		attrVal1=attrVal1,
		attrVal2=attrVal2,
		attrVal3=attrVal3,
		level=level,
		scale=scale,
		highLightObj = self,
		}
	WndTips:show(element,self.m_root,23,tData,ccp(-45,0))
end

--@brief	幻化等级
function WndPlayerInfo:onTip6(element)
	WZLog("WndPlayerInfo:onTip6")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = 6

	local tData = {}
	local shapeId = CacheCenter:getPlayerInfo().shapeId
	local shapeLevel = CacheCenter:getPlayerInfo().shapeLevel
	tData.lv = shapeLevel
	tData.id = shapeId
	if tData.lv > 0 then
		WndTips:show(element,self.m_root,38,tData,ccp(-60,0))
	else
		WndTips:show(element,self.m_root,39,tData,ccp(-60,0))
	end
end
-------------------------------------语言适配模块Begin----------------------------------------

--@brief   多语言版本文本
function WndPlayerInfo:_moreLanguage()
	if self.m_root == nil then
		return
	end
	local tCell = nil
	--角色信息
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO2)
	--战斗属性
	GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO3)
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO4)
end

--@brief   编辑框的中文策略
function WndPlayerInfo:_setSupportMultiChar(bChar)
	local editSign = WZUIEditBox:luaTo(self.m_root:getChildElement("editSign_WndPlayerInfo"))
	editSign:setSupportMultiChar(bChar)
end

--@brief	设置控件静态文本
function WndPlayerInfo:_setUIStaticText()
	--属性名称
	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.HEALTH..":")
	GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.ATTACK..":")
	GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.DEFENSE..":")
	GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.CRIT..":")
	GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.FREESTORM..":")
	GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.AVOIDINJURY..":")
	GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.TIZHI..":")
	GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.POWER..":")
	GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.PRACTICE_ARMOR..":")
	GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.AGILITY..":")
	GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LUCKY..":")
	GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.ANTIBREAKING..":")	
	GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.RANGE..":")
end

function WndPlayerInfo:_adaptLanguage_vn()
    WZLog("WndPlayerInfo:_adaptLanguage_vn ")
    GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setFontSize(18)

    local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setFontSize(18)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setFontSize(18)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setFontSize(18)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setFontSize(18)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setFontSize(18)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setFontSize(18)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setFontSize(18)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setFontSize(18)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setFontSize(18)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setFontSize(18)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setFontSize(18)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setFontSize(18)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setFontSize(18)

    attr1:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.633333,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.753333,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr13:setRelativePosition(GlobalMethod:ccp(0.57333,0.5))

	GetElement(self.m_root,"txtPlayerId_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.715,0.5))
end

function WndPlayerInfo:_adaptLanguage_th()
	WZLog("WndPlayerInfo:_adaptLanguage_th")
	for i=1,13 do
    	GetElement(self.m_root,"attrTitle" .. i .. "_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
    end

     local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setFontSize(18)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setFontSize(18)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setFontSize(18)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setFontSize(18)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setFontSize(18)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setFontSize(18)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setFontSize(18)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setFontSize(18)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setFontSize(18)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setFontSize(18)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setFontSize(18)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setFontSize(18)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setFontSize(18)

    attr1:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.673333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.753333,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.673333,0.5))
    attr13:setRelativePosition(GlobalMethod:ccp(0.67333,0.5))

   --角色信息
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	--战斗属性
	GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
end

function WndPlayerInfo:_adaptLanguage_en()
    WZLog("WndPlayerInfo:_adaptLanguage_en ")

    -- local attrTitle6 = GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF)
    -- attrTitle6:setDimensions(GlobalMethod:CCSize(100))
    -- attrTitle6:setScale(0.6)

    local attrTitle1 = GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF)
    local attrTitle2 = GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF)
    local attrTitle3 = GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF)
    local attrTitle4 = GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF)
    local attrTitle5 = GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF)
    local attrTitle6 = GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF)
    local attrTitle7 = GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF)
    local attrTitle8 = GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF)
    local attrTitle9 = GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF)
    local attrTitle10 = GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF)
    local attrTitle11 = GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF)
    local attrTitle12 = GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF)
    local attrTitle13 = GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF)
    attrTitle1:setScale(0.8)
	attrTitle2:setScale(0.8)
	attrTitle3:setScale(0.8)
	attrTitle4:setScale(0.8)
	attrTitle5:setScale(0.8)
	attrTitle6:setScale(0.8)
	attrTitle7:setScale(0.8)
	attrTitle8:setScale(0.8)
	attrTitle9:setScale(0.8)
	attrTitle10:setScale(0.8)
	attrTitle11:setScale(0.8)
	attrTitle12:setScale(0.8)
	attrTitle13:setScale(0.8)

    local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    local attr2 = GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    local attr4 = GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
	attr2:setScale(0.8)
	attr3:setScale(0.8)
	attr4:setScale(0.8)
	attr5:setScale(0.8)
	attr6:setScale(0.8)
	attr7:setScale(0.8)
	attr8:setScale(0.8)
	attr9:setScale(0.8)
	attr10:setScale(0.8)
	attr11:setScale(0.8)
	attr12:setScale(0.8)
	attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.280001,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.353333,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.306667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.526667,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.653333,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.526667,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.533334,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.433333,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.446667,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.366667,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.439629,0.5))
    attr13:setRelativePosition(GlobalMethod:ccp(0.446667,0.5))

   --角色信息
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	--战斗属性
	GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
end

function WndPlayerInfo:_adaptLanguage_pt(  )
    local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setRelativePosition(GlobalMethod:ccp(0.326667,0.5))
    local attr2 = GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setRelativePosition(GlobalMethod:ccp(0.4,0.5))
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setRelativePosition(GlobalMethod:ccp(0.413333,0.5))
    local attr4 = GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setRelativePosition(GlobalMethod:ccp(0.36,0.5))
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setRelativePosition(GlobalMethod:ccp(0.74,0.5))
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setRelativePosition(GlobalMethod:ccp(0.826667,0.5))
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setRelativePosition(GlobalMethod:ccp(0.626667,0.5))
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setRelativePosition(GlobalMethod:ccp(0.493333,0.5))
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setRelativePosition(GlobalMethod:ccp(0.726667,0.5))
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setRelativePosition(GlobalMethod:ccp(0.793333,0.5))
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setRelativePosition(GlobalMethod:ccp(0.473333,0.5))
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setRelativePosition(GlobalMethod:ccp(0.699628,0.497783))
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setRelativePosition(GlobalMethod:ccp(0.653334,0.5))

    attr1:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.633333,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.673333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.73,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.573333,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.46,0.5))
    attr13:setRelativePosition(GlobalMethod:ccp(0.43,0.5))

   --角色信息
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	--战斗属性
	local txtFight = GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF)
	txtFight:setFontSize(18)
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"ttfBagTitle_WndBag",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtPlayerId_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	local attrTitle6 = GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF)
	attrTitle6:setFontSize(16)
	attrTitle6:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
	local attrTitle12 = GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF)
	attrTitle12:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
	local attrTitle13 = GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF)
	attrTitle13:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
end

function WndPlayerInfo:_adaptLanguage_tr(  )
	for i=1,13 do
    	local attrTitle = GetElement(self.m_root,"attrTitle" .. i .. "_WndPlayerInfo",WZUILabelTTF)
    	if i == 6 then
    		attrTitle:setFontSize(14)
    	else
    		attrTitle:setFontSize(18)
    	end
    	local attr = GetElement(self.m_root,"attr" .. i .. "_WndPlayerInfo",WZUILabelTTF)
    	attr:setFontSize(18)
    end

    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
   local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)

    attr5:setRelativePosition(GlobalMethod:ccp(0.673333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.673333,0.5))

   --角色信息
	local txtUser = GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF)
	txtUser:setFontSize(17)
	--战斗属性
	local txtFight = GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF)
	txtFight:setFontSize(14)
	txtFight:setRelativePosition(GlobalMethod:ccp(0.005,0.835714))
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"ttfBagTitle_WndBag",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtPlayerId_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
end

function WndPlayerInfo:_adaptLanguage_es(  )
	for i=1,13 do
    	GetElement(self.m_root,"conAttr" .. i .. "_WndPlayerInfo",WZUIContainer):setScale(0.8)
    end

    GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.326667,0.5))
    GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.56,0.5))
    GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.64,0.5))
    GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.36,0.5))
    GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.706667,0.5))
    GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.806666,0.5))
    GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.606667,0.5))
    GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.506667,0.5))
    GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.466667,0.5))
    GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.5))
    GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.11963,0.497783))
    GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.573333,0.5))

	GetElement(self.m_root,"conAttr1_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.98))
	GetElement(self.m_root,"conAttr2_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.78))
	GetElement(self.m_root,"conAttr3_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.58))
	GetElement(self.m_root,"conAttr4_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.38))
	GetElement(self.m_root,"conAttr5_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.18))
	GetElement(self.m_root,"conAttr7_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.98))
	GetElement(self.m_root,"conAttr8_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.78))
	GetElement(self.m_root,"conAttr9_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.58))
	GetElement(self.m_root,"conAttr10_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.38))
	GetElement(self.m_root,"conAttr11_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.43,0.18))
	GetElement(self.m_root,"conAttr12_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.74,0.98))
	GetElement(self.m_root,"conAttr6_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.74,0.78))
	GetElement(self.m_root,"conAttr13_WndPlayerInfo",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.74,0.58))

   --角色信息
	local txtUser = GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF)
	txtUser:setScale(0.65)
	txtUser:setDimensions(GlobalMethod:CCSize(140))
	txtUser:setRelativePosition(GlobalMethod:ccp(0.0146667,0.96))

	--战斗属性
	local txtFight = GetElement(self.m_root,"txtFight_WndPlayerInfo",WZUILabelTTF)
	txtFight:setScale(0.65)
	txtFight:setDimensions(GlobalMethod:CCSize(140))
	txtFight:setRelativePosition(GlobalMethod:ccp(0.0191111,0.978571))
	
	--个性签名
	GetElement(self.m_root,"txtSign_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"ttfBagTitle_WndBag",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtPlayerId_WndPlayerInfo",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"freeTxtID_WndPlayerInfo",WZUILabelTTF):setFontSize(16)
end
-------------------------------------私有方法模块End----------------------------------------
