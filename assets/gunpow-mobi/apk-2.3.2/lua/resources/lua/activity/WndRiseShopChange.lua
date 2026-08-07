--WndRiseShopChange.lua
--@brief	WndRiseShopChange的UI模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路商店兑换


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRiseShopChange:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRiseShopChange:onExit(element)
	self:_unInit()
end
function WndRiseShopChange:showInterface(data, refreshTime)
	local wndChange = WndRiseShopChange:createElement(data, refreshTime)
	if wndChange ~= nil then
	    WindowManager:addWindow(wndChange,WndRiseShopChange,nil,false)
	end
end
function WndRiseShopChange:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndRiseShopChange:actionCallback()
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local tabItem = GDatatab_item["id_"..self.m_tChangeData.id]
	if tabItem then
		local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
		local itemInfo = {lastTime=self.m_tChangeData.num,lastNum=self.m_tChangeData.num,basicInfo=CopyTable(tabItem)}
		local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setScale(0.95)
		goods_con:addChild(celElement)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(WndRiseShop,self.onItemClick)
	end
	if self.m_tChangeData.buyLimit ~= -1 then --没有限购的时候
		local txtRichLimit = GetElement(self.m_root,"txtRichLimit",WZUIFreeTextBox)
		self.m_nMaxCount = self.m_tChangeData.buyLimit - self.m_tChangeData.buyCount
		txtRichLimit:setShowText(string.format(LocalStrings.ACTIVITY_TEXT64,self.m_tChangeData.buyLimit, self.m_nMaxCount))
	end
	local txtHasMoney = GetElement(self.m_root,"txtHasMoney",WZUILabelTTF)
	local num =  CacheCenter:getPlayerItemCountById(160107)
	txtHasMoney:setText(num)
	self.m_nHsaMoney = num
	self:setBuyCount(self.m_nCount)
end
function WndRiseShopChange:onBtnRedu()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCount = self.m_nCount - 1
	if self.m_nCount <= 0 then
		self.m_nCount = 1
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT66)
		return
	end
	self:setBuyCount(self.m_nCount)
end
function WndRiseShopChange:onBtnAdd()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCount = self.m_nCount + 1
	if (self.m_tChangeData.price * self.m_nCount) > self.m_nHsaMoney then
		self.m_nCount = self.m_nCount - 1
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT68)
		return
	end
	if self.m_nMaxCount and self.m_nCount > self.m_nMaxCount then
		self.m_nCount = self.m_nMaxCount
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT67)
		return
	end
	self:setBuyCount(self.m_nCount)
end
function WndRiseShopChange:setBuyCount(num)
	local txtChangeCount = GetElement(self.m_root,"txtChangeCount",WZUILabelTTF)
	txtChangeCount:setText(num)
	local txtConsume = GetElement(self.m_root,"txtConsume",WZUILabelTTF)
	txtConsume:setText(self.m_tChangeData.price * num)
end

function WndRiseShopChange:onBtnChange()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_tChangeData.price * self.m_nCount) > self.m_nHsaMoney then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT68)
		return
	end
	local tab = {}
	tab.refreshTime = self.m_nRefreshTime
	tab.id = self.m_tChangeData.shop_id
	tab.num = tonumber(self.m_nCount)
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7019, 5, tab)
end

function WndRiseShopChange:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
