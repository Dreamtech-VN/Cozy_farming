--WndSellNum.lua
--@brief	WndSellNum的UI模块
--@date		2015/09/17
--@author	zsq
--@note		开启宝箱


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSellNum:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndSellNum:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSellNum:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief	关闭
function WndSellNum:onClose(element)
	WZLog("WndSellNum:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndSellNum:show(tData)
	local wnd = WndSellNum:createElement()
    WindowManager:addWindow(wnd, WndSellNum,true,true,nil)
	self:setData(tData)
end

--@brief	确认
function WndSellNum:onClick(element)
	WZLog("WndSellNum:onClick",self.playerItemId)
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = CopyTable(self.m_tData)
	tData.lastNum = self.m_nNum
	--使用甜甜圈
	WndSell:onRightItemClick1(tData)
	self:onClose()
end

--@brief	减少10个
function WndSellNum:onMutiReduce(element)
	WZLog("WndSellNum:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 1 then
		self.m_nNum = math.max(1, self.m_nNum - 10)
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndSellNum",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	减少1个
function WndSellNum:onReduce(element)
	WZLog("WndSellNum:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndSellNum",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	增加10个
function WndSellNum:onMutiAdd(element)
	WZLog("WndSellNum:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum < self.m_nMaxNum then
		self.m_nNum = math.min(self.m_nMaxNum, self.m_nNum + 10)
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	GetElement(self.m_root,"useNum_WndSellNum",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	增加1个
function WndSellNum:onAdd(element)
	WZLog("WndSellNum:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum + 1 <= self.m_nMaxNum then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	GetElement(self.m_root,"useNum_WndSellNum",WZUILabelTTF):setText(self.m_nNum)
end

--@brief	点击礼包
function WndSellNum:onClickGift()
    WndItemInfo:showInfo(GetElement(self.m_root,"con3_WndSellNum",WZUIContainer),self.m_root,1,self.m_tData,false)
end

--@brief	点击窗口
function WndSellNum:onTouchBegan()

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置数据
function WndSellNum:setData(tData)
	if tData == nil then return end
	self.m_tData = tData
	self.playerItemId = tData.playerItemId
	self.m_nNum = tData.lastNum
	self.m_nMaxNum = tData.lastNum
	WZLog("WndSellNum:setData", Serialize(self.m_tData))
	self:update()
end

--@brief 更新界面
function WndSellNum:update()
	local tData = self.m_tData

    local celElement,tLuaObj = CellGoodItem:createElement()
    tLuaObj:setCellGoodItem(tData, 4)
    tLuaObj:setItemClickFun(self, self.onClickGift)
	GetElement(self.m_root,"con3_WndSellNum",WZUIContainer):removeAllChildrenWithCleanup(true)
	GetElement(self.m_root,"con3_WndSellNum",WZUIContainer):addChild(celElement)

	GetElement(self.m_root,"useNum_WndSellNum",WZUILabelTTF):setText(self.m_nNum)
end

-------------------------------------私有方法模块End----------------------------------------

