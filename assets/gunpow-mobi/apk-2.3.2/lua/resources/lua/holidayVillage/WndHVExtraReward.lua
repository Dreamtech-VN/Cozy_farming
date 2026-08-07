--WndHVExtraReward.lua
--@brief	WndHVExtraReward的UI模块
--@date		2022/07/29
--@author	XTX
--@note		度假村-额外奖励界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVExtraReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVExtraReward:onExit(element)
	self:_unInit()
end

--@brief 	加载完成回调
function WndHVExtraReward:onEnterTransitionDidFinish(element)
	WZLog("WndHVExtraReward:onEnterTransitionDidFinish")
	self:_setStaticText()
	self:_update()
end

--@brief 	点击收下按钮回调
function WndHVExtraReward:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WindowManager:removeWindow(self.m_root, self, true)
	SceneHolidayVillage:showFixedReward()
end

--@brief 	点击物品回调
function WndHVExtraReward:onClickItem(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root,1,tData,false, nil, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVExtraReward:_setStaticText()
	GetElement(self.m_root, "txtTitle_WndHVExtraReward", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[87])
end

--@brief 	刷新
function WndHVExtraReward:_update()
	local ftxtAtt = GetElement(self.m_root, "ftxtAtt_WndHVExtraReward", WZUIFreeTextBox)
	local conReward = GetElement(self.m_root, "conReward_WndHVExtraReward", WZUIContainer)
	local basidData = GDatatab_item["id_" .. self.m_tData.id]
	local strContent = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[88], basidData.name)
	ftxtAtt:setShowText(strContent)

	local nCount = #self.m_tData.itemIds
	local nPadding = 0.76
	local nStartPos = 0.5 - (nCount - 1) / 2 * nPadding
	for i = 1, #self.m_tData.itemIds do 
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tData.itemIds[i], self.m_tData.itemNums[i], 15)
			tNewObj:setItemClickFun(self, self.onClickItem)
			element:setRelativePosition(GlobalMethod:ccp(nStartPos + (i - 1)*nPadding, 0.5))
			element:setScale(0.8)
			tNewObj:_showItemNum()

			conReward:addChild(element)
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
