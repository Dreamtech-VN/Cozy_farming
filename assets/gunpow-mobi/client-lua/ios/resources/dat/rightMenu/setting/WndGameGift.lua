--WndGameGift.lua
--@brief	WndGameGift的UI模块
--@date		2015/04/28
--@author	binshao
--@note		设置界面的游戏兑换礼包



-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameGift:onEnter(element)
    WZLog("WndGameGift:onEnter")
	self.m_root = element
	--注册兑换协议
	ProtocolProcessorWndRedemptionCode:regAll()
	AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndGameGift:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndGameGift:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameGift:onExit(element)
    WZLog("WndGameGift:onExit")
	self:_unInit()
	--注销协议
	ProtocolProcessorWndRedemptionCode:unregAll()
end

function WndGameGift:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndGameGift , true)--关闭设置窗口
end

-- @brief  关闭兑换礼物界面Btn
function WndGameGift:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
end


function WndGameGift:onBtnCancel( )
	self:onBtnClose()
end

--点击兑换按钮
function WndGameGift:onBtnExchange( )
	WZLog("WndGameGift当前数据",self.m_sExchangeword )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local editStr = GetElement(self.m_root,"editExchangeword_WndGameGift",WZUIEditBox)
	local word = editStr:getText()


    if self.m_root == nil then return end
	if word and word ~= "" then
--		--用正则验证兑换码格式
--		if string.find(self.m_sExchangeword,"%w%w%w%w%w%-%w%w%w%w%w%-%w%w%w%w%w%-%w%w%w%w%w") == nil then
--			WZLog("兑换码格式不合要求")
--			MsgBoxManager:showTipBox(LocalStrings.SETTING_EXCHANGEWORD3)
--		else
--			ProtocolProcessorWndRedemptionCode:send_EXCHANGECODE_SendExchangeCode(word)
--		end
		WZLog("-----------------cur word-----------------",word)
		ProtocolProcessorWndRedemptionCode:send_EXCHANGECODE_SendExchangeCode(word)
	else
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndGameGift:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtExchange_WndGameGift",WZUILabelTTF):setFontSize(23)
end

function WndGameGift:_adaptLanguage_pt(  )
	local txtGift = GetElement(self.m_root,"txtGift_WndGameGift",WZUILabelTTF)
	txtGift:setScale(0.9)
	txtGift:setRelativePosition(GlobalMethod:ccp(0.05,0.67))
end

function WndGameGift:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtGift_WndGameGift",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,0.67))
	GetElement(self.m_root,"txtExchange_WndGameGift",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End-----------------------------------