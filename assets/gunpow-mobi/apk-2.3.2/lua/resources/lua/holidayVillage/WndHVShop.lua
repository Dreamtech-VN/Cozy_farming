--WndHVShop.lua
--@brief	WndHVShop的UI模块
--@date		2022/05/30
--@author	XTX
--@note		度假村-商店界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVShop:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVShop:onExit(element)
	if self.m_root then 
		self.m_root:disableSchedule()
	end
	
	self:_unInit()
end

--@brief 	加载完成回调
function WndHVShop:onEnterTransitionDidFinish(element)
	WZLog("WndHVShop:onEnterTransitionDidFinish")
	self:_setStaticText()
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp(self.m_nTabIndex, 0, 0)
	self.m_root:enableSchedule("_caculateTime", 1)
end

--@brief 	点击关闭按钮回调
function WndHVShop:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, WndHVShop , true)
end

--@brief 	切换商品类型
function WndHVShop:onClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 
	self.m_nTabIndex = nTag
	if self.m_tShopData[nTag] == nil then 
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_ShopOp(self.m_nTabIndex, 0, 0)
		return 
	end 
	
	self:_update()
end

--@brief 	点击物品格子回调
function WndHVShop:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置静态文本
function WndHVShop:_setStaticText()
	GetElement(self.m_root, "txtTab1_WndHVShop", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[17])
	GetElement(self.m_root, "txtTab1Sel_WndHVShop", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[17])
	GetElement(self.m_root, "txtTab2_WndHVShop", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[18])
	GetElement(self.m_root, "txtTab2Sel_WndHVShop", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[18])
	
end

--@brief 	刷新
function WndHVShop:_update()
	local tbGoodsList = GetElement(self.m_root, "tbGoodsList_WndHVShop", WZUITableContainer)
	tbGoodsList:cleanTable()

	local tShopData = self.m_tShopData[self.m_nTabIndex]
	self.m_tCellItem = {}

	for i = 1, #tShopData do
		local element, tNewObj = CellHVGoodsItem:createElement()
        if element == nil or tNewObj == nil then
            return 
        end
        element:setTag(i - 1)
        tNewObj:setData(tShopData[i])
        tbGoodsList:setCellElement(element)

        table.insert(self.m_tCellItem, tNewObj)
	end
end

--@brief 	计时器
function WndHVShop:_caculateTime()
	if self.m_nRefreshInterval <= 0 then return end 

	self.m_nRefreshInterval = self.m_nRefreshInterval - 1
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndHVShop:_adaptLanguage_vn()
	GetElement(self.m_root, "txtTab1_WndHVShop", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtTab1Sel_WndHVShop", WZUILabelTTF):setFontSize(14)
end

-------------------------------------语言适配End----------------------------------------
