--WndGameGoodsGet.lua
--@brief	WndGameGoodsGet的UI模块
--@date		2021/01/13
--@author	hyx
--@note		实物领取


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameGoodsGet:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameGoodsGet:onExit(element)
	self:_unInit()
end
function WndGameGoodsGet:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndGameGoodsGet:actionCallback()
	self:initShow()
end
function WndGameGoodsGet:initShow()
	self.m_sEeditReceiv = GetElement(self.m_root,"editReceiv_WndGameGoodsGet",WZUIEditBox)
    self.m_sEeditReceiv:setPlaceHolder(LocalStrings.OPTIMIZE_TEXT36)
    self.m_sEditNumber = GetElement(self.m_root,"editNumber_WndGameGoodsGet",WZUIEditBox)
    self.m_sEditNumber:setPlaceHolder(LocalStrings.OPTIMIZE_TEXT37)
    self.m_sEditAddress = GetElement(self.m_root,"editAddress_WndGameGoodsGet",WZUIEditBox)
    self.m_sEditAddress:setPlaceHolder(LocalStrings.OPTIMIZE_TEXT38)
    ProtocolProcessorRecycling:regAll1()
end
--收件人
function WndGameGoodsGet:onEditReceivBegin()
end
function WndGameGoodsGet:onEditReceivEnd()
	local text = self.m_sEeditReceiv:getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT39)
	end
end
--电话号码
function WndGameGoodsGet:onEditNumberBegin()
end
function WndGameGoodsGet:onEditNumberEnd()
	local text = self.m_sEditNumber:getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT40)
		return
	end
	local function judgePhoneNum(str)
		str = tostring(str)
	    return string.match(str,"[1][3-9]%d%d%d%d%d%d%d%d%d") == str
	end
	local boolstr = judgePhoneNum(text)
	if boolstr == false then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT41)
		return
	end
end
--详细地址
function WndGameGoodsGet:onEditAddressBegin()
end
function WndGameGoodsGet:onEditAddressEnd()
	local text = self.m_sEditAddress:getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT42)
		return
	end
end

function WndGameGoodsGet:onBtnClickSubmit()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local text1 = self.m_sEeditReceiv:getText()
	local text2 = self.m_sEditNumber:getText()
	local text3 = self.m_sEditAddress:getText()
	if text1 == "" or text2 == "" or text3 == "" then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT43)
		return
	end
	local function callSpend()
		local content = {}
		content.name = text1
		content.mobile = text2
		content.address = text3
		content = json.encode(content)
		ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeItem(self.m_nPlayerItemId, 1, content )
	end
	MsgBoxManager:showConfirmBox(LocalStrings.OPTIMIZE_TEXT46, self, callSpend)
end
function WndGameGoodsGet:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
