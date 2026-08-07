--WndMasterBuyBox.lua
--@brief	WndMasterBuyBox的UI模块
--@date		2021/08/17
--@author	hyx
--@note		师门购买宝箱


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterBuyBox:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterBuyBox:onExit(element)
	self:_unInit()
end
function WndMasterBuyBox:showInterface()
	local wndbox = WndMasterBuyBox:createElement()
	if wndbox ~= nil then
	    WindowManager:addWindow(wndbox,WndMasterBuyBox,nil,false)
	end
end
function WndMasterBuyBox:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMasterBuyBox:actionCallback()
	local bagPrice = CacheCenter:getGameParam().bagPrice
	if bagPrice then
		local ids,num = SplitItemString(bagPrice)
		for i=1,3 do
			local conBox = GetElement(self.m_root,"conBox"..i,WZUIContainer)
			local richPrice = GetElement(conBox,"richPrice",WZUIFreeTextBox)
			self.m_tBuyBoxData[i] = {ids[i], num[i]}
			local info = GDatatab_item["id_"..tonumber(ids[i])]
			if info then
				richPrice:setShowText(string.format([[<I Z="0.35">%s</I><T C="127,70,26" S="20" P="1"> %d</T>]],info.icon, tonumber(num[i])))
			end
			self.m_tImgSelect[i] = GetElement(conBox,"chooseBoxSelect",WZUIContainer)
		end
	end
end
function WndMasterBuyBox:onBtnChooseBox(element)
	local tag = element:getTag()
	if self.m_nSelectBoxIndex then
		self.m_tImgSelect[self.m_nSelectBoxIndex]:setVisible(false)
	end
	self.m_tImgSelect[tag]:setVisible(true)
	self.m_nSelectBoxIndex = tag
end

function WndMasterBuyBox:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_nSelectBoxIndex then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT70)
		return
	end
	local data = self.m_tBuyBoxData[self.m_nSelectBoxIndex]
	local monNum = CacheCenter:getPlayerItemCountById(tonumber(data[1]))
	if tonumber(data[1]) == 70 then
		if monNum < tonumber(data[2]) then
			if not JudgeMoneyIsEnough(70, tonumber(data[2]), nil, nil, nil, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
		        return 
		    end
		else
			ProtocolProcessorWndMaster:send_MENTORING_BuyBag(self.m_nSelectBoxIndex)
		end
	elseif tonumber(data[1]) == 2 then
		if monNum < tonumber(data[2]) then
		 	MsgBoxManager:showTipBox(LocalStrings.GOLD1..LocalStrings.NOT_ENABLE)
		else
			ProtocolProcessorWndMaster:send_MENTORING_BuyBag(self.m_nSelectBoxIndex)
		end
	else
		local monNum = CacheCenter:getPlayerItemCountById(tonumber(data[1]))
		if monNum < tonumber(data[2]) then
			MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, self,self.clickSureMoney)
		else
			ProtocolProcessorWndMaster:send_MENTORING_BuyBag(self.m_nSelectBoxIndex)
		end
	end
end
function WndMasterBuyBox:sureUseDiamondInstead()
	ProtocolProcessorWndMaster:send_MENTORING_BuyBag(self.m_nSelectBoxIndex)
end
--@brief	点击确定充值回调
function WndMasterBuyBox:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_Guild_Shop)
	PassportSdkManager:gotoPaymentPage()
end
function WndMasterBuyBox:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
