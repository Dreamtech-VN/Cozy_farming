--CellWeddingItem.lua
--@brief	CellWeddingItem的UI模块
--@date		2014/4/23
--@author	LQK
--@note		婚礼列表中的项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWeddingItem:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWeddingItem:onExit(element)
	self:_unInit()
end


--@brief	点击单元格被调用的函数
function CellWeddingItem:onCelBtn(element)
	WZLog("CellWeddingItem:onCelBtn(element)")
	element = WZUICheckBox:luaTo(element)
	local nIndex = element:getCheckIndex()
	WZLog("nIndex = ",nIndex)
	--WZLog("self.m_nDtataTableIndex = ",self.m_nDtataTableIndex)
	if nIndex == 0 then 
		SceneWeddingDaily:onCellBtn(self.m_nDtataTableIndex)
	end
end

--@brief	取得复选框在复选框中组中索引的函数
--@param	element:表绑定的UI节点引用 
--@return 复选框 索引
function CellWeddingItem:getCheckBoxIndex(element)
	if element == nil then 
		WZLog("CellWeddingItem:getCheckBoxIndex(element) element is nil")
		return nil
	end 
	local checkBox = element:getChildElement("checkBg_CellWeddingItem")
	if checkBox ~= nil then 
		return WZUICheckBox:luaTo(checkBox):getCheckIndex()
	end 
	return nil
end 



--@brief	设置复选框在复选框组中状态的函数
--@param #1	element:表绑定的UI节点引用 
--@param #2 nState 复选框状态
function CellWeddingItem:setCheckBoxStates(element,nState)
	if element == nil then 
		WZLog("setCheckBoxStates(element,nState) element is nil")
		return 
	end 
	local checkBox = element:getChildElement("checkBg_CellWeddingItem")
	if checkBox ~= nil and nState ~= nil  then 
		WZUICheckBox:luaTo(checkBox):setCheckIndex(nState)
	end 

end 


--@brief	设置复选框按钮是否可触摸的函数
--@param #1	element:表绑定的UI节点引用 
--@param #2 bFlag 是否可用
function CellWeddingItem:setCheckBoxTououEnable(element,bFlag)
	if element == nil then 
		WZLog("CellWeddingItem:setCheckBoxTououEnable() element is nil")
		return 
	end 
	local checkBox = element:getChildElement("checkBg_CellWeddingItem")
	if checkBox ~= nil and bFlag ~= nil  then 
		WZUICheckBox:luaTo(checkBox):setTouchEnable(bFlag)
	end 

end 




-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	cell更新函数
--@note     实际上的初始化函数
function CellWeddingItem:_update()
    if self.m_root == nil then
        WZLog("CellWeddingItem:_update() m_root is nil.")
        return
    end
    --婚礼现场ID
	WZLog("self.m_nWeddingId = ",self.m_nWeddingId)
	--因为ID==新郎ID+新娘ID，不易控制超框，所以大于8位数字将被截断
	local sWeddingId = tostring(self.m_nWeddingId)
	if #sWeddingId >7 then sWeddingId = string.sub(sWeddingId, 1, 7) end
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtWedddingId_CellWeddingItem")):setText(sWeddingId)
    --新郎名字
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBrigeGroomName_CellWeddingItem")):setText(self.m_sBrigeGroomName)
    if self.m_nManServerId ~= CacheCenter:getPlayerInfo().serverId then 
    	GetElement(self.m_root, "imgKuafuIconMan_CellWeddingItem", WZUIImage):setVisible(true)
    	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBrigeGroomName_CellWeddingItem")):setRelativePosition(GlobalMethod:ccp(0.46,0.81))
    end
	--新娘名字
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBrigeName_CellWeddingItem")):setText(self.m_sBrigeName)
    if self.m_nWomanServerId ~= CacheCenter:getPlayerInfo().serverId then 
    	GetElement(self.m_root, "imgKuafuIconWoman_CellWeddingItem", WZUIImage):setVisible(true)
    	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtBrigeName_CellWeddingItem")):setRelativePosition(GlobalMethod:ccp(0.46,0.56))
    end

    --婚礼状态(0未开始，1进行中，2结束)
    local strWeddingStatus = LocalStrings.MARRY_DESC_10
	if self.m_nWeddingStatus == 0 then  
		strWeddingStatus = LocalStrings.MARRY_DESC_10
	elseif self.m_nWeddingStatus == 1 then 
		strWeddingStatus = LocalStrings.MARRY_DESC_11
	else
		strWeddingStatus = LocalStrings.MARRY_DESC_11
	end
	GetElement(self.m_root,"txtWeddingStates_CellWeddingItem",WZUILabelTTF):setText(strWeddingStatus)

    --结婚时间
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtTime_CellWeddingItem")):setText(self.m_sWeddingTime)
	 --模式  0：普通 1：浪漫 2：豪华 3：奢华
	WZLog("self.m_nWeddingMode = ",self.m_nWeddingMode)
	local imgWeddingType = GetElement(self.m_root,"imgWeddingType_CellWeddingItem",WZUIImage)
	if self.m_nWeddingMode == 1 then
		imgWeddingType:setFile("ui/marrige/common_icon_schl.png")
	elseif self.m_nWeddingMode == 2 then
		imgWeddingType:setFile("ui/marrige/common_icon_hhhl.png")
	elseif self.m_nWeddingMode == 3 then
		imgWeddingType:setFile("ui/marrige/common_icon_lmhl.png")
	end

	if self.m_bUserPass then
		GetElement(self.m_root,"imgWeddingHallPass_CellWeddingItem",WZUIImage):setVisible(true)
	end


	local imgWeddingHallPass = GetElement(self.m_root,"imgWeddingHallPass_CellWeddingItem",WZUIImage)
	local txtWedddingId = GetElement(self.m_root,"txtWedddingId_CellWeddingItem",WZUILabelTTF)
	local conWedddingProgress = GetElement(self.m_root,"conWedddingProgress_CellWeddingItem",WZUIContainer)
	local txtWedddingProgress = GetElement(self.m_root,"txtWedddingProgress_CellWeddingItem",WZUILabelTTF)
	txtWedddingId:setRelativePosition(GlobalMethod:ccp(0.83,0.36))
	imgWeddingHallPass:setRelativePosition(GlobalMethod:ccp(0.71,0.31))
	conWedddingProgress:setVisible(true)
	if self.m_nProgress == 1 then
		txtWedddingProgress:setText(LocalStrings.MARRY_DESC_18)
	elseif self.m_nProgress == 2 then
		txtWedddingProgress:setText(LocalStrings.MARRY_DESC_19)
	elseif self.m_nProgress == 3 then
		txtWedddingProgress:setText(LocalStrings.MARRY_DESC_20)
	elseif self.m_nProgress == 4 then
		txtWedddingProgress:setText(LocalStrings.MARRY_DESC_21)
	else
		txtWedddingId:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
		imgWeddingHallPass:setRelativePosition(GlobalMethod:ccp(0.71,0.5))
		conWedddingProgress:setVisible(false)
	end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
--@brief   葡文适配函数
function  CellWeddingItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTimeName_CellWeddingItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22176,0.5))
	GetElement(self.m_root,"txtTime_CellWeddingItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.409743,0.5))
end

function  CellWeddingItem:_adaptLanguage_th(  )
	local txtFemale = GetElement(self.m_root,"txtFemale_CellWeddingItem",WZUILabelTTF)
	txtFemale:setRelativePosition(GlobalMethod:ccp(0.260943,0.560423))

	local txtBrigeName = GetElement(self.m_root,"txtBrigeName_CellWeddingItem",WZUILabelTTF)
	txtBrigeName:setRelativePosition(GlobalMethod:ccp(0.398615,0.574618))
end

function  CellWeddingItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTimeName_CellWeddingItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.233123,0.5))
	GetElement(self.m_root,"txtTime_CellWeddingItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.458985,0.5))
end

function  CellWeddingItem:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtWeddingStates_CellWeddingItem",WZUILabelTTF):setFontSize(16)
end

function CellWeddingItem:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtBrigeGroomName_CellWeddingItem",WZUILabelTTF):setFontSize(16)
	local txtFemale = GetElement(self.m_root,"txtFemale_CellWeddingItem",WZUILabelTTF)
	txtFemale:setRelativePosition(GlobalMethod:ccp(0.26,0.560423))
	local txtBrigeName = GetElement(self.m_root,"txtBrigeName_CellWeddingItem",WZUILabelTTF)
	txtBrigeName:setRelativePosition(GlobalMethod:ccp(0.4,0.574618))
	txtBrigeName:setFontSize(16)

	local txtTimeName = GetElement(self.m_root,"txtTimeName_CellWeddingItem",WZUILabelTTF)
	txtTimeName:setScale(0.7)
	txtTimeName:setRelativePosition(GlobalMethod:ccp(0.25,0.5))

	local txtTime = GetElement(self.m_root,"txtTime_CellWeddingItem",WZUILabelTTF)
	txtTime:setScale(0.7)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function CellWeddingItem:_adaptLanguage_ug(  )
	local txtMale = GetElement(self.m_root,"txtMale_CellWeddingItem",WZUILabelTTF)
	txtMale:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtMale:setRelativePosition(GlobalMethod:ccp(0.8,0.839468))
	local txtFemale = GetElement(self.m_root,"txtFemale_CellWeddingItem",WZUILabelTTF)
	txtFemale:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtFemale:setRelativePosition(GlobalMethod:ccp(0.8,0.560423))
	local txtBrigeGroomName = GetElement(self.m_root,"txtBrigeGroomName_CellWeddingItem",WZUILabelTTF)
	txtBrigeGroomName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtBrigeGroomName:setRelativePosition(GlobalMethod:ccp(0.52,0.838407))
	local txtBrigeName = GetElement(self.m_root,"txtBrigeName_CellWeddingItem",WZUILabelTTF)
	txtBrigeName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtBrigeName:setRelativePosition(GlobalMethod:ccp(0.52,0.574618))

	local txtTimeName = GetElement(self.m_root,"txtTimeName_CellWeddingItem",WZUILabelTTF)
	txtTimeName:setScale(0.8)
	txtTimeName:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	local txtTime = GetElement(self.m_root,"txtTime_CellWeddingItem",WZUILabelTTF)
	txtTime:setScale(0.8)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.1,0.5))
end
-------------------------------------语言适配模模块End----------------------------------------


