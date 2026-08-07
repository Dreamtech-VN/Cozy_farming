--WndMarryParty.lua
--@brief	WndMarryParty的UI模块
--@date		2015/05/27
--@author	qixiang_xie
--@note		婚礼请柬


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryParty:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryParty:onExit(element)
	self:_unInit()
end

--@brief  初始化信息
function WndMarryParty:_update()
	WZLog("WndMarryParty:update")
	if self.m_tInCards == nil or  #self.m_tInCards <= 0 then
		return 
	end
	local manName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtMan_WndMarryParty"))
	local womanName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWoman_WndMarryParty"))
	manName:setText("")
	womanName:setText("")

	local time = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWeddingTime_WndMarryParty"))
	local cardExplain = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCardsExplain_WndMarryParty"))
	cardExplain:setText("")
	time:setText("")
	if self.m_tInCards~= nil and #self.m_tInCards > 0 then
	    manName:setText(LocalStrings.BRIGE_GROOM_NAME .. self.m_tInCards[1].manName)
	    womanName:setText(LocalStrings.BRIGE_NAME .. self.m_tInCards[1].womanName)
	    time:setText(os.date("%y-%m-%d %H:%M",self.m_tInCards[1].startDate))
	    if ProjConfig.LANGUAGE == "vn" then
	    	time:setText(os.date("%H:%M %d-%m-%y",self.m_tInCards[1].startDate))
	    end
	    cardExplain:setText(LocalStrings.INVITATION_TIP)
	end
	
	local imgWeddingDress = GetElement(self.m_root,"imgWeddingDress_WndMarryParty",WZUIImage)
	if self.m_tInCards[1].marryType == 1 then
		imgWeddingDress:setFile("ui/marrige/common_pic_jhxc3.png")
	elseif self.m_tInCards[1].marryType == 2 then
		imgWeddingDress:setFile("ui/marrige/common_pic_jhxc2.png")
	elseif self.m_tInCards[1].marryType == 3 then
		imgWeddingDress:setFile("ui/marrige/common_pic_jhxc.png")
	end
	table.remove(self.m_tInCards,1)
end

--@brief   获取到结婚请柬
function WndMarryParty:getInCard(manName, womanName, startDate, cardType,marryType)
	WZLog("WndMarryParty:getInCard")
	if self.m_root == nil then
		local element = WndMarryParty:createElement()
		self.m_tInCards = {}
		for i=1,#manName do
			local cardInfo = {}
			cardInfo.manName = manName[i]
			cardInfo.womanName = womanName[i]
			cardInfo.startDate = startDate[i]
			cardInfo.cardInfo = cardInfo[i]
			cardInfo.cardType = cardType[i]
			cardInfo.marryType = marryType[i]
			table.insert(self.m_tInCards,cardInfo)
	    end
		WindowManager:addWindow(element,WndMarryParty,true,nil,nil,true)
	else
		for i=1,#manName do
			local cardInfo = {}
			cardInfo.manName = manName[i]
			cardInfo.womanName = womanName[i]
			cardInfo.startDate = startDate[i]
			cardInfo.cardInfo = cardInfo[i]
			cardInfo.cardType = cardType[i]
			cardInfo.marryType = marryType[i]
			table.insert(self.m_tInCards,cardInfo)
	    end
	end
end


-------------------------------------公有方法模块End----------------------------------------

-------------------------------------点击响应模块Begin--------------------------------------
--@brief   关闭按钮响应事件(关闭当前窗口)
function WndMarryParty:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	if self.m_tInCards ~= nil and #self.m_tInCards > 0 then
		self:_update()
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  发送邀请
function WndMarryParty:onClickSendIn(element)
    WZLog("WndMarryParty:onClickSendIn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if friendId == nil then
	   MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_ID)
	   return 
	end

	if self.m_nInType ==1 then
		if not JudgeMoneyIsEnough(1,28,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,97) then
            return
        end
	elseif self.m_nInType ==2 then
		if not JudgeMoneyIsEnough(1,18,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,97) then
            return
        end
	elseif self.m_nInType==3 then
		if not JudgeMoneyIsEnough(1,8,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,97) then
            return
        end
	end

	local friendIds = WZLuaVector_int_:create()
	for i,v in ipairs(self.m_nFriendId) do
		VansPriceID:push(v)
	end
	WndMarryManager:createLoading()
	ProtocolProcessorWndMarry:send_WEDDING_SendCard(friendIds,self.m_nInType,self.m_nFriendIndex)
end

-------------------------------------点击响应模块End----------------------------------------

-------------------------------------回调方法模块Begin--------------------------------------

-------------------------------------回调方法模块Begin--------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function WndMarryParty:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txt_WndMarryParty",WZUILabelTTF):setFontSize(15)
    GetElement(self.m_root,"txtCardsExplain_WndMarryParty",WZUILabelTTF):setFontSize(15)
    GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280))
end

function WndMarryParty:_adaptLanguage_th(  )
    GetElement(self.m_root,"txt_WndMarryParty",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280))
end


function WndMarryParty:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280))
    GetElement(self.m_root,"txtCardsExplain_WndMarryParty",WZUILabelTTF):setScale(0.75)
end
function WndMarryParty:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280))
end

function WndMarryParty:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtCardsExplain_WndMarryParty",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF):setScale(0.8)
end

function WndMarryParty:_adaptLanguage_ug(  )
    local txtCardsExplain = GetElement(self.m_root,"txtCardsExplain_WndMarryParty",WZUILabelTTF)
    txtCardsExplain:setScale(0.7)
    txtCardsExplain:setDimensions(GlobalMethod:CCSize(400))
    local txtMarryPartyExplain = GetElement(self.m_root,"txtMarryPartyExplain_WndMarryParty",WZUILabelTTF)
    txtMarryPartyExplain:setScale(0.8)
    txtMarryPartyExplain:setDimensions(GlobalMethod:CCSize(320))
    local txtSelectFriend = GetElement(self.m_root,"txtSelectFriend_WndMarryParty",WZUILabelTTF)
    txtSelectFriend:setFontSize(14)
    txtSelectFriend:setDimensions(GlobalMethod:CCSize(60))
end
-------------------------------------语言适配模模块End----------------------------------------