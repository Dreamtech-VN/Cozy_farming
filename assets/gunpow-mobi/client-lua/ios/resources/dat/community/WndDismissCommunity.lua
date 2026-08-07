--WndDismissCommunity.lua
--@brief	WndDismissCommunity的UI模块
--@date		2013/12/27
--@author	林庆凯
--@note		询问解散公会,会长让位,会员升级,刷新商店的窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDismissCommunity:onEnter(element)
	self.m_root = element
	 --多语言版本界面适配
    AdaptLanguage(self)
    WindowManagerAni:createAction(element,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDismissCommunity:onExit(element)
	self:_unInit()
end

--@brief	关闭窗口的函数
--@param	element:表绑定的UI节点引用
function WndDismissCommunity:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		 SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

function WndDismissCommunity:onCloseActionCallback()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndDismissCommunity, true)
	end 
end

--@brief	点击确定按钮的函数
--@param	element:表绑定的UI节点引用
function WndDismissCommunity:onSureBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFlagWindow == 2 or self.m_nFlagWindow == 3 then       --退出公会窗口
		ProtocolProcessorSceneCommunity:send_GUILD_Resignations()
	end 
	if self.m_nFlagWindow == 5 then
		--判断贡献是否足够
		local cost
		for k,v in pairs(GDatatab_vip_restriction) do
			if v.type == 8 and v.parameter == 2 then
				cost = v.cost[1][2]
			end
		end
		if CacheCenter:getMoneyList().blueDiamond >= cost then
			--刷新商品
			ProtocolProcessorSceneCommunity:send_GUILD_RefreshGuildStore()
		else
			--钻石不足
			PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep1, Chat_Channel_Guild_Shop)
			MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, self,self.clickSureMoney)
		end
	end
	self:onCloseWindowBtn()
end 

--@brief	点击确定充值回调
function WndDismissCommunity:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_Guild_Shop)
	PassportSdkManager:gotoPaymentPage()
end

--@brief	点击取消按钮的函数
--@param	element:表绑定的UI节点引用
function WndDismissCommunity:onCancelBtn(element)
	WZLog("WndDismissCommunity:onCancelBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndDismissCommunity, true)
	end 
end 



--@brief	点击升级公会的确定按钮的函数
--@brief	点击开除公会的确定按钮的函数
--@param	element:表绑定的UI节点引用
function WndDismissCommunity:onUpGradeBtnBtn(element)
	WZLog("WndDismissCommunity:onUpGradeBtnBtn",self.m_nCelPlayerId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nFlagWindow == 1 then 	--是否开除公会
		if self.m_bLimit and SceneMemberList.m_nFireNum <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.ARE_YOU_SURE_DISMISS_THIS_PLAYER2)
			return
		else
    		local ids = WZLuaVector_int_:create()
			ids:push(self.m_nCelPlayerId)
			ProtocolProcessorSceneCommunity:send_GUILD_ExpelMember(ids )
			--SceneMemberList.m_nFireNum = SceneMemberList.m_nFireNum - 1
		end
		if self.m_root ~= nil then 
			WindowManager:removeWindow(self.m_root, WndDismissCommunity, true)
		end 
	elseif self.m_nFlagWindow == 4 then   --是否升级公会
		WZLog("WndDismissCommunity:onUpGradeBtnBtn(element)")
		ProtocolProcessorSceneCommunity:send_COMMUNITY_Upgrade()
	end 
end 


 
--@brief	点击会长让位的函数
--@param	element:表绑定的UI节点引用
function WndDismissCommunity:onPresidentYesBtn(element)
	--公长让位协议
	WZLog("self.m_nCelPlayerId = ",self.m_nCelPlayerId)
	ProtocolProcessorSceneCommunity:send_GUILD_Abdicate(self.m_nCelPlayerId )
end 



--@brief	把会长让位容器设为可见的函数
function WndDismissCommunity:setPresidentContainerVisable()
	if self.m_root == nil then 
		WZLog("WndDismissCommunity:destroyPresidentContainer self.m_root is nil ")
		return 
	end 
	GetElement(self.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.POPUPMENUSTRING13)
	
	--设置是否让位文本
	self:_setTextContent(LocalStrings.ASK_YES_OR_NO_GIVEWAY)
	
	local conPresidentGiveWay = self.m_root:getChildElement("conPresidentGiveWay_WndDismissCommunity")
	if conPresidentGiveWay ~= nil then 
		conPresidentGiveWay = WZUIContainer:luaTo(conPresidentGiveWay)
		conPresidentGiveWay:setVisible(true)
		self:_destroyDissmissCommunityBtnContainer()
	end 
end 

--@brief	把会长让位容器删除掉的函数
function WndDismissCommunity:destroyPresidentContainer()
	if self.m_root == nil then 
		WZLog("WndDismissCommunity:destroyPresidentContainer() self.m_root is nil ")
		return 
	end 
		
	local conPresidentGiveWay = self.m_root:getChildElement("conPresidentGiveWay_WndDismissCommunity")
	if conPresidentGiveWay ~= nil then 
		conPresidentGiveWay = WZUIContainer:luaTo(conPresidentGiveWay)
		conPresidentGiveWay:removeFromParentAndCleanup(true)
	end 
end 



--@brief	把确定取消按钮设为可见还是只有一个升级公会的确定按钮可不可见
--@param	nFlag #1 表示按钮容器可见，2为按钮确定可见
function WndDismissCommunity:setBtnVisable(nFlag)
	WZLog("=============00")
	if self.m_root == nil then 
		WZLog("WndDismissCommunity:setBtnVisable(nFlag) self.m_root is nil ")
		return 
	end 
	--nFlag = 1，按钮容器可见
	local btnCon = self.m_root:getChildElement("btnCon_WndDismissCommunity")
	WZLog("=============22")
	if btnCon ~= nil then 
		btnCon = WZUIContainer:luaTo(btnCon)
		if nFlag == 1  then  
			   local txtSure = self.m_root:getChildElement("txtSure_WndDismissCommunity")
			   local txtCancel = self.m_root:getChildElement("txtCancel_WndDismissCommunity")
               if txtSure and txtCancel then 
	           		WZUILabelTTF:luaTo(txtSure):setText(LocalStrings.CONFIRM)
	           		WZUILabelTTF:luaTo(txtCancel):setText(LocalStrings.CANCEL)
	           end
			btnCon:setVisible(true)
		else 
			btnCon:setVisible(false)
		end 
	end 
	--nFlag = 2，按钮确定可见
	local btnUpGradeBtn = self.m_root:getChildElement("btnUpGradeBtn_WndDismissCommunity")
	if btnUpGradeBtn ~= nil then 
		btnUpGradeBtn = WZUIButton:luaTo(btnUpGradeBtn)
		if btnUpGradeBtn ~= nil then 
			if nFlag == 2  then  
				btnUpGradeBtn:setVisible(true)

		      local txtOK = self.m_root:getChildElement("txtOK_WndDismissCommunity")
	            if txtOK then 
		         WZUILabelTTF:luaTo(txtOK):setText(LocalStrings.CONFIRM)
	            end 
				
			else 
				btnUpGradeBtn:setVisible(false)
			end 
		end 
	end 
end 

--@brief	设置文本内容的函数
--@param   sTxtMidContent 文本内容
function WndDismissCommunity:setTxtMidContent(sTxtMidContent)
	WZLog("WndDismissCommunity:setTxtMidContent(sTxtMidContent)",sTxtMidContent)
	if self.m_root == nil then 
		WZLog(" WndDismissCommunity:setTxtMidContent(sTxtMidContent) self.m_root is nil ")
		return 
	end 
	
	local  txtMidContent = self.m_root:getChildElement("txtMidContent_WndDismissCommunity")
	if txtMidContent ~= nil then 
		txtMidContent = WZUILabelTTF:luaTo(txtMidContent)
		if txtMidContent ~= nil then 
			txtMidContent:setText(sTxtMidContent)
		end 
	end 
	WZLog("WndDismissCommunity:setTxtMidContent(sTxtMidContent)")
end 


--@brief	提供给公会场景弹出是否开除公会会员用的接口函数
function WndDismissCommunity:setCommunityFriedWindow(nTime, name)
	if self.m_root == nil then 
		WZLog(" WndDismissCommunity:setCommunityFriedWindow() self.m_root is nil ")
		return 
	end 
	GetElement(self.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.POPUPMENUSTRING6)
	
	self.m_nFlagWindow = 1   --开除公会会员窗口 
	
	--设置内容:你确定将该玩家开除？
	local nnTime = nTime
	if nnTime == nil then nnTime = SystemTime:getServerTime() - 86400 * 4 end
	local offLineTime = SystemTime:getServerTime() - nnTime
	local tips = LocalStrings.ARE_YOU_SURE_DISMISS_THIS_PLAYER
	--成员在线或者离线3天内，限制开除次数
	if SceneMemberList.m_nState == 1 or offLineTime < 86400 * 3 then
		self.m_bLimit = true
		tips = string.format(LocalStrings.ARE_YOU_SURE_DISMISS_THIS_PLAYER1, name, SceneMemberList.m_nFireNum)
	else
		self.m_bLimit = false
		tips = string.format(LocalStrings.ARE_YOU_SURE_DISMISS_THIS_PLAYER, name)
	end
	self:setTxtMidContent(tips)
	
	--确定按钮可见
	local btnUpGradeBtn = self.m_root:getChildElement("btnUpGradeBtn_WndDismissCommunity")
	if btnUpGradeBtn ~= nil then 
		btnUpGradeBtn = WZUIButton:luaTo(btnUpGradeBtn)
		if btnUpGradeBtn ~= nil then 
			btnUpGradeBtn:setVisible(true)
		end 
	end 
	self:_destroyDissmissCommunityBtnContainer()
end 



--@brief	提供给我的公公场景中弹出是否退出公会窗口用的接口函数
function WndDismissCommunity:setExitCommunityWindow()
	if self.m_root == nil then 
		WZLog(" WndDismissCommunity:setExitCommunityWindow() self.m_root is nil ")
		return 
	end 
	
	self.m_nFlagWindow = 2   --退出公会窗口 

	--标题退出公会
	GetElement(self.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.COMMUNITY6)
	
	--设置内容:退出公会将清除公会贡献，确定退出公会？
	self:setTxtMidContent(LocalStrings.COMMUNITYINFO53)
end 

--@brief	公会商城是否消耗贡献刷新商品
function WndDismissCommunity:setRefreshShopItem()
	if self.m_root == nil then 
		return 
	end 
	GetElement(self.m_root, "txtTitle_WndDismiss", WZUILabelTTF):setText(LocalStrings.REFRESH)
	
	self.m_nFlagWindow = 5   --刷新商品窗口 
	
	--是否花费%d贡献刷新？
	local cost
	for k,v in pairs(GDatatab_vip_restriction) do
		if v.type == 8 and v.parameter == 2 then
			cost = v.cost[1][2]
		end
	end
	self:setTxtMidContent(string.format(LocalStrings.COMMUNITYINFO46,cost))
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	把确定取消按钮的取消按钮显示出来
function WndDismissCommunity:_destroyDissmissCommunityBtnContainer()
	WZLog("WndDismissCommunity:_destroyDissmissCommunityBtnContainer")
	if self.m_root == nil then 
		WZLog("WndDismissCommunity:destroyDissmissCommunityBtnContainer() self.m_root is nil ")
		return 
	end 
	
	local btnCon = self.m_root:getChildElement("btnCon_WndDismissCommunity")
	if btnCon ~= nil then 
		btnCon = WZUIContainer:luaTo(btnCon)
		if btnCon ~= nil then 
			--btnCon:removeFromParentAndCleanup(true)
			btnCon:setVisible(true)
	 		GetElement(self.m_root, "btnSure_WndDismissCommunity", WZUIButton):setVisible(false)
	 		GetElement(self.m_root, "btnCancel_WndDismissCommunity", WZUIButton):setVisible(true)
	 		--GetElement(self.m_root, "btnCancel_WndDismissCommunity", WZUIButton):setRelativePosition(GlobalMethod:ccp(0.28,0.5))

		    local txtCancel = self.m_root:getChildElement("txtCancel_WndDismissCommunity")
            if txtCancel then 
            	WZUILabelTTF:luaTo(txtCancel):setText(LocalStrings.CANCEL)
            end
		end 
	end 
end 

--@brief	设置文本的函数
function WndDismissCommunity:_setTextContent(sTxt)
	if self.m_root == nil then 
		WZLog("WndDismissCommunity:_setTextContent(sTxt) self.m_root is nil ")
		return 
	end 
	
	local txtPresdientGiveWayYesOrNo = self.m_root:getChildElement("txtPresdientGiveWayYesOrNo_WndDismissCommunity")
	if  txtPresdientGiveWayYesOrNo ~= nil then 
		txtPresdientGiveWayYesOrNo = WZUILabelTTF:luaTo(txtPresdientGiveWayYesOrNo)
		if txtPresdientGiveWayYesOrNo ~= nil then 
			txtPresdientGiveWayYesOrNo:setText(sTxt)
		end 
	end 
end 



-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配模块Begin----------------------------------------
--@brief	葡语适配函数
--@return	无
--@note		备注
function WndDismissCommunity:_adaptLanguage_pt()
	local txtSure_WndDismissCommunity = GetElement(self.m_root, "txtSure_WndDismissCommunity", WZUILabelTTF)
	txtSure_WndDismissCommunity:setScaleX(0.6)
	txtSure_WndDismissCommunity:setScaleY(0.8)
    local txtCancel_WndDismissCommunity = GetElement(self.m_root, "txtCancel_WndDismissCommunity", WZUILabelTTF)
	 txtCancel_WndDismissCommunity:setScaleX(0.6)
	 txtCancel_WndDismissCommunity:setScaleY(0.8)


	 local txtOK_WndDismissCommunity = GetElement(self.m_root, "txtOK_WndDismissCommunity", WZUILabelTTF)
	 txtOK_WndDismissCommunity:setScaleX(0.7)
	 txtOK_WndDismissCommunity:setScaleY(0.8)
	 GetElement(self.m_root,"txtPresdientGiveWayYesOrNo_WndDismissCommunity",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(370))
	
end 

function WndDismissCommunity:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtPresdientGiveWayYesOrNo_WndDismissCommunity",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(330,0))
end

function WndDismissCommunity:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtMidContent_WndDismissCommunity",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtPresdientGiveWayYesOrNo_WndDismissCommunity",WZUILabelTTF):setFontSize(18)
end
function WndDismissCommunity:_adaptLanguage_es(  )
	local txtPresdientGiveWayYesOrNo = GetElement(self.m_root,"txtPresdientGiveWayYesOrNo_WndDismissCommunity",WZUILabelTTF)
	txtPresdientGiveWayYesOrNo:setDimensions(GlobalMethod:CCSize(350))
end
------------------------------------语言适配模块End----------------------------------------