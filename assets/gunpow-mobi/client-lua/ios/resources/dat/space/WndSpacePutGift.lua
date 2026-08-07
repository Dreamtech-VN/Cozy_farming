--WndSpacePutGift.lua
--@brief	WndSpacePutGift的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人放置空间礼物


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpacePutGift:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self.m_nCount = 1
	self:updateCost()
	self.m_nMaxNum = 100 - WndSpaceMain.m_tData.giftNum
	if self.m_nMaxNum == 0 then
		self.m_nCount = 0
		self:updateCost()
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpacePutGift:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpacePutGift:onClose(element)
    WZLog("WndSpacePutGift:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	确定
function WndSpacePutGift:onConfirm(element)
    WZLog("WndSpacePutGift:onConfirm")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCount == 0 and self.m_nMaxNum == 0 then
		MsgBoxManager:showTipBox(LocalStrings.SPACE42)
		WindowManager:removeWindow(self.m_root, self, true)
		return
	end
	if self.m_nCount == 0 and self.m_nMaxNum ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.SPACE43)
		return
	end
	--判断是否有足够钻石
	if CacheCenter:getGameParam().isUseTicket == "0" then
		if JudgeMoneyIsEnough(70,self.m_nCount*WndSpaceMain.m_tData.giftPrice,nil,nil,130, self, self.closeWin, nil, nil, self, self.sureToUseDiamondInstead) then
			self:sureToUseDiamondInstead()
		end
	else
		if JudgeMoneyIsEnough(1,self.m_nCount*WndSpaceMain.m_tData.giftPrice,nil,nil,130, self, self.closeWin, nil, nil, self, self.sureToUseDiamondInstead) then
			self:sureToUseDiamondInstead()
		end
	end
end

--@brief 	关闭窗口
function WndSpacePutGift:closeWin()
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	确认用钻石替换礼券增加礼物
function WndSpacePutGift:sureToUseDiamondInstead()
	-- body
	ProtocolProcessorWndSpace:send_SPACE_BuyGift(self.m_nCount)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	增加
function WndSpacePutGift:onAdd(element)
    WZLog("WndSpacePutGift:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCount < self.m_nMaxNum then
		self.m_nCount = self.m_nCount + 1
		self:updateCost()
	else
		MsgBoxManager:showTipBox(LocalStrings.SPACE42)
	end
end

--@brief	减少
function WndSpacePutGift:onReduce(element)
    WZLog("WndSpacePutGift:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCount > 0 then
		self.m_nCount = self.m_nCount - 1
		self:updateCost()
	end
end

--@brief	批量增加
function WndSpacePutGift:onMutiAdd(element)
    WZLog("WndSpacePutGift:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCount < (self.m_nMaxNum - 9) then
		self.m_nCount = self.m_nCount + 10
		self:updateCost()
	end
end

--@brief	批量减少
function WndSpacePutGift:onMutiReduce(element)
    WZLog("WndSpacePutGift:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCount > 9 then
		self.m_nCount = self.m_nCount - 10
		self:updateCost()
	end
end

--@brief	更新礼物数量和消耗钻石
function WndSpacePutGift:updateCost()
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nCount)
	GetElement(self.m_root,"ttfCost_WndSpacePutGift",WZUILabelTTF):setText(self.m_nCount*WndSpaceMain.m_tData.giftPrice)
	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndSpacePutGift", WZUIImage)
	if imgCostIcon then
		if CacheCenter:getGameParam().isUseTicket == "0" then
			imgCostIcon:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon:setScale(0.5)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSpacePutGift:_adaptLanguage_vn()
	GetElement(self.m_root,"txt_WndSpacePutGift",WZUILabelTTF):setFontSize(19)
end

function WndSpacePutGift:_adaptLanguage_en()
	GetElement(self.m_root,"txt_WndSpacePutGift",WZUILabelTTF):setFontSize(17)
end

function WndSpacePutGift:_adaptLanguage_pt(  )
	local txtCostS = GetElement(self.m_root,"txtCostS_WndSpacePutGift",WZUILabelTTF)
	txtCostS:setRelativePosition(GlobalMethod:ccp(0.395487,0.34))
	local ttfCost = GetElement(self.m_root,"ttfCost_WndSpacePutGift",WZUILabelTTF)
	ttfCost:setRelativePosition(GlobalMethod:ccp(0.565,0.34))
end

function WndSpacePutGift:_adaptLanguage_es(  )
	GetElement(self.m_root,"txt_WndSpacePutGift",WZUILabelTTF):setFontSize(16)

	local txtCostS = GetElement(self.m_root,"txtCostS_WndSpacePutGift",WZUILabelTTF)
	txtCostS:setRelativePosition(GlobalMethod:ccp(0.367282,0.34))

	local ttfCost = GetElement(self.m_root,"ttfCost_WndSpacePutGift",WZUILabelTTF)
	ttfCost:setRelativePosition(GlobalMethod:ccp(0.565,0.34))
	
end

function WndSpacePutGift:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txt_WndSpacePutGift",WZUILabelTTF):setFontSize(17)
end
-------------------------------------语言适配End--------------------------------------------
