--WndChristmasTreeBag.lua
--@brief	WndChristmasTreeBag的UI模块
--@date		2017/12/06
--@author	Tianxiang_Xu
--@note		圣诞树活动临时背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndChristmasTreeBag:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndChristmasTreeBag:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndChristmasTreeBag:onEnterTransitionDidFinish()
	-- body
	self:_update()
end

--@brief 	点击关闭按钮回调
function WndChristmasTreeBag:onCloseClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	self:closeWindow()
end

--@brief 	关闭界面
function WndChristmasTreeBag:closeWindow()
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击一键整理按钮回调
function WndChristmasTreeBag:onClickArrange(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBagList == nil or #self.m_tBagList == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT14)
		return 
	end

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_SortChristmasGiftBack( )
end

--@brief 	点击全部提取按钮回调
function WndChristmasTreeBag:onClickPickUp(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBagList == nil or #self.m_tBagList == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHRISTMASTREE_TEXT14)
		return 
	end

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetChristmasGift( )
end

--@brief    其它Item点击回调
function WndChristmasTreeBag:onOthersClick(luaTable, tag, tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndChristmasTreeBag.m_root, 1, tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	每帧更新一排装备
function WndChristmasTreeBag:_update()
	if self.m_tBagList == nil then self.m_tBagList = {} end

	local tableConGoods = GetElement(self.m_root,"tableConGoods_WndChristmasTreeBag",WZUITableContainer)
	tableConGoods:cleanTable()
	tableConGoods:setLoadCountPerFrame(4)

	local conLeftBg = GetElement(self.m_root, "conLeftBg_WndChristmasTreeBag", WZUIContainer)
	if #self.m_tBagList == 0 then 
		ShowPanelNullTip( conLeftBg, LocalStrings.CHRISTMASTREE_TEXT15)
	else
		removeShowPanelNullTip(conLeftBg)
	end

	for i = 1, #self.m_tBagList do
		local celElement, tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setTag(i - 1)
			tableConGoods:setCellElement(celElement)
			tCell:setCellGoodLocalId(self.m_tBagList[i].id, self.m_tBagList[i].num, 2)
			tCell:setItemClickFun(self, self.onOthersClick)
		end
	end
	--设置格子数量
	GetElement(self.m_root, "itemNum_WndChristmasTreeBag", WZUILabelTTF):setText(#self.m_tBagList.."/".. self.m_nBagMaxNum)
end





-------------------------------------私有方法模块End----------------------------------------
