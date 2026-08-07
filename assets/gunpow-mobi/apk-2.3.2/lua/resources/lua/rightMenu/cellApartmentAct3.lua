--cellApartmentAct3.lua
--@brief	cellApartmentAct3的UI模块
--@date		2021/09/29
--@author	hyc
--@note		小推车活动cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function cellApartmentAct3:onEnter(element)
	self.m_root = element
end

--@brief 	开始加载
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function cellApartmentAct3:onExit(element)
	self:_unInit()
end

function cellApartmentAct3:onLoadData(element)
	WZLog("cellApartmentAct3:onLoadData")
	local cellElement = WZUISystem:getInstance():createElement("cellApartmentAct3")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)
	self:showView()

	GetElement(self.m_root,"conChoose_cellApartmentAct3",WZUIContainer):setVisible(self.m_bChoose)
	
	-- AdaptLanguage(self)
end

function cellApartmentAct3:showView()
	-- body
	WZLog("cellApartmentAct3:showView",Serialize(self.m_tData))
	local tdata = self.m_tData
	local conItemInfo = GetElement(self.m_root,"conItemInfo_cellApartmentAct3",WZUIContainer)
	conItemInfo:removeAllChildrenWithCleanup(true)
    local  itemInfo =	GDatatab_item["id_" .. tdata[11]]
    local txtLimit = GetElement(self.m_root,"txtLimit",WZUIFreeTextBox)
    if tdata[14] == 0 then 
    	local strFormat = [[<T C="127,70,26" S="18" P="1">%s</T>]]
    	txtLimit:setShowText(string.format(strFormat,LocalStrings.UNLIMITED_PURCHASE))
    elseif tdata[14] == 1 then
    	txtLimit:setShowText(string.format(LocalStrings.DAY_LIMIT,tdata[13],tdata[16]))
    elseif tdata[14] == 2 then
    	txtLimit:setShowText(string.format(LocalStrings.TOTAL_LIMIT,tdata[13],tdata[16]))
    end
	local eItem, tItem = CellGoodItem:createElement()
	eItem:setScale(1)
	tItem:setItemClickFun(self, self.onItem3)

	local mData = {
	    id = tdata[11],
	    isUse = false,
	    data = "",
	    playerItemId = -1,
	    lastNum = tdata[3],
	    basicInfo = GetItemLocalData(tdata[11])
	}
	tItem:setCellGoodItem(mData, 4)
	if tItem.m_txtCount ~= nil then
		tItem.m_txtCount:setRelativePosition(ccp(0.92,0.1))
	end
	conItemInfo:addChild(eItem)

	local txtName = GetElement(self.m_root,"txtPacksName_cellApartmentAct3",WZUILabelTTF)
	txtName:setText(itemInfo.name)
	if tdata[13] == 0 then
		GetElement(self.m_root,"imgSoldOut_cellApartmentAct3",WZUIImage):setVisible(true)
	end

	local imgOut = GetElement(self.m_root,"imgSoldOut_cellApartmentAct3",WZUIImage)
	imgOut:setVisible(false)
	if tdata[13] <= 0 then
		imgOut:setVisible(true)
	end
	-- GetElement(self.m_root,"txtLimit1",WZUILabelTTF):setText(LocalStrings.SHOP_LIMIT_TITLE..":")
	-- GetElement(self.m_root,"txtLimit2",WZUILabelTTF):setText()
end

function cellApartmentAct3:onItem3(tItem, nTag, tData)
	-- body
	WZLog("cellApartmentAct3:onItem3")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndItemInfo:showInfo(self.m_root,WndApartmentAct.m_root,1,tData,false)
end

function cellApartmentAct3:OnChoose(element)

	-- local conChoose = GetElement(self.m_root,"conChoose_cellApartmentAct3",WZUIContainer)
	-- conChoose:setVisible(true)
	local tdata = self.m_tData
	WZLog("cellApartmentAct3:OnChoose",Serialize(self.m_tData))
	WndApartmentAct:ChooseItem(tdata)
end

function cellApartmentAct3:setChooseImg(bChoose)
	self.m_bChoose = bChoose
	local conChoose = GetElement(self.m_root,"conChoose_cellApartmentAct3",WZUIContainer)
	if conChoose then
		conChoose:setVisible(bChoose)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
