--WndFund.lua
--@brief	WndFund的UI模块
--@date		2015/11/02
--@author	zsq
--@note		成长基金


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFund:onEnter(element)
	self.m_root = element
	ProtocolProcessorFund:regAll()
end

--@brief	打开加载动画
function WndFund:onEnterTransitionDidFinish(element)
	ProtocolProcessorFund:send_FUNDGROW_GetFundInfo()
    self:createLoadingUI()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFund:onExit(element)
	self:_unInit()
	ProtocolProcessorFund:unregAll()
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndFund:onClose(element)
    WZLog("WndFund:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndFund:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	购买基金
function WndFund:onBuy()
	WZLog("WndFund:onBuy")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if tonumber(CacheCenter:getPlayerInfo().vipLevel) < tonumber(CacheCenter:getGameParam().fundviplimit) then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.FUNDINFO4, self, self.needMoreDiamondCallBack, nil, tCustomUIConfig)
		return
	end
	
	local ids,nums = SplitItemString(CacheCenter:getGameParam().fundDiamondLimit)
	if not JudgeMoneyIsEnough(tonumber(ids[1]), tonumber(nums[1]), LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_Fund, nil, nil, nil, nil, ProtocolProcessorFund, ProtocolProcessorFund.send_FUNDGROW_BuyFundgrow) then
		return 
	end

	ProtocolProcessorFund:send_FUNDGROW_BuyFundgrow()
end

--@brief	提示充值框的回调
--@param	nId:消息id
--@param	nResType:响应类型(超时，确定，取消)
function WndFund:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief	点击确定充值回调
function WndFund:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_GameActivity)
	PassportSdkManager:gotoPaymentPage()
end

--@brief	点击充值
function WndFund:onCharge()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	PassportSdkManager:gotoPaymentPage()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function WndFund:update()
	local freeListContainer = GetElement(self.m_root,"freeCon_WndFund",WZUIFreeListContainer)
	freeListContainer:removeAll()

	if self.m_bBuy then
		freeListContainer:setContentSize(GlobalMethod:CCSize(495,320))
    	GetElement(self.m_root,"btnBuy",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"btnBuy1",WZUIButton):setVisible(false)
	else
    	GetElement(self.m_root,"btnBuy",WZUIButton):setVisible(true)
    	GetElement(self.m_root,"btnBuy1",WZUIButton):setVisible(true)
	end

	self.m_nStartIndex = 1
	if self.m_tCellList == nil then self.m_tCellList = {} end
	--freeListContainer:enableSchedule("_addCell",0)
	self:_addCell()
end

--@brief	每帧加载Cell
function WndFund:_addCell(element, t)
	local freeListContainer = GetElement(self.m_root,"freeCon_WndFund",WZUIFreeListContainer)
	local endIndex = #self.m_tData
	for i = self.m_nStartIndex, endIndex do
		local celElement,tCell
		if self.m_tCellList[i] == nil then
			celElement,tCell = CellFund:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				freeListContainer:pushBack(celElement)
			end 
		else
			tCell = self.m_tCellList[i]
		end
		tCell:update(self.m_tData[i])
		freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y+113*self.m_numberOfReceived)
		self.m_nStartIndex = self.m_nStartIndex + 1
	end 

	if freeListContainer:getMoveElement():getPositionY() > freeListContainer:getMaxPosition().y then
		freeListContainer:getMoveElement():setPositionY(freeListContainer:getMaxPosition().y)
	end
end
  
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin-----------------------------------------
function WndFund:_adaptLanguage_en(  )
    GetElement(self.m_root,"txt2_gotoButton",WZUILabelTTF):setScale(0.9)
end

function WndFund:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txt1_gotoButton",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txt2_gotoButton",WZUILabelTTF):setScale(0.85)
end

function WndFund:_adaptLanguage_es(  )
	local txt2 = GetElement(self.m_root,"txt2_gotoButton",WZUILabelTTF)
	txt2:setDimensions(GlobalMethod:CCSize(130,0))
	txt2:setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------