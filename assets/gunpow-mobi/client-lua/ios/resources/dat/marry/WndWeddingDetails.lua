--WndWeddingDetails.lua
--@brief	WndWeddingDetails的UI模块
--@date		2016/04/14
--@author	qixiang_xie
--@note		婚礼详情


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWeddingDetails:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:showWeddingInfo()
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWeddingDetails:onExit(element)
	self:_unInit()
end

--@brief  根据婚礼类型，显示婚礼信息
function WndWeddingDetails:showWeddingInfo()
	WZLog("WndWeddingDetails:showWeddingInfo")
	local conMoveing = GetElement(self.m_root,"conMoveing_WndWeddingDetails",WZUITableContainer)
	local imgTitle = GetElement(self.m_root,"imgTitle_WndWeddingDetails",WZUIImage)
	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
    local txtWeddingCount = GetElement(self.m_root,"txtWeddingCount_WndWeddingDetails",WZUILabelTTF)
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndWeddingDetails", WZUIImage)


	local weddingP = CacheCenter:getGameParam().wedMarryItem
    local ids,nums = SplitItemString(weddingP)
	if self.m_nCurShowWeddingType == 1 then
		imgTitle:setFile("ui/common/marry_icon_jhshhl.png")
		txtDressInfo:setShowText(LocalStrings.WEDDING_TYPE_1_TIP)
		txtWeddingType:setText(LocalStrings.WEDDING_LUXURY)
		txtWeddingCount:setText(nums[1])
	elseif self.m_nCurShowWeddingType == 2 then
		imgTitle:setFile("ui/common/marry_icon_jhhhhl.png")
		txtDressInfo:setShowText(LocalStrings.WEDDING_TYPE_2_TIP)
		txtWeddingType:setText(LocalStrings.WEDDING_RICH)
		txtWeddingCount:setText(nums[2])
	elseif self.m_nCurShowWeddingType == 3 then
		imgTitle:setFile("ui/common/marry_icon_jhlmhl.png")
		txtDressInfo:setShowText(LocalStrings.WEDDING_TYPE_3_TIP)
		txtWeddingType:setText(LocalStrings.WEDDING_ROMAN)
		txtWeddingCount:setText(nums[3])
	end

    if imgCostIcon then
        imgCostIcon:setFile(GDatatab_item["id_" .. ids[self.m_nCurShowWeddingType]].icon)
        imgCostIcon:setScale(0.5)
    end

	local cost = txtWeddingCount:getText()
	cost = tonumber(cost)

	if JudgeMarryDiscountExist() then
		local txtWeddingDiscount = GetElement(self.m_root,"txtWeddingDiscount_WndWeddingDetails",WZUILabelTTF)
	    local txtWeddingLine = GetElement(self.m_root,"txtWeddingLine_WndWeddingDetails",WZUILabelTTF)
	    txtWeddingDiscount:setVisible(true)
	    txtWeddingLine:setVisible(true)
	    local temp = nil
	    if self.m_nCurShowWeddingType == 1 then
	    	temp = math.ceil(cost*0.5)
	    elseif self.m_nCurShowWeddingType == 2 then
	    	temp = math.ceil(cost*0.7)
	    elseif self.m_nCurShowWeddingType == 3 then
	    	temp = math.ceil(cost*0.9)
	    	txtWeddingLine:setRelativePosition(GlobalMethod:ccp(0.734208,0.575))
	    end
	    txtWeddingDiscount:setText(cost)
	    txtWeddingCount:setText(temp)
	end
	
	local weddingInfo = GDatatab_wedding_show["id_" .. self.m_nCurShowWeddingType]
	local tEquip = {}
	local playerSex = CacheCenter:getPlayerInfo().sex
	for k,v in pairs(weddingInfo.item_show) do
		table.insert(tEquip,v[1])
	end
	local sex = CacheCenter:getPlayerInfo().sex
	local man = CreatePlayerFigure(0,tEquip)
	local girl = CreatePlayerFigure(1,tEquip)

	local conGirl = GetElement(self.m_root,"conGirl_WndWeddingDetails",WZUIContainer)
	local conMan = GetElement(self.m_root,"conMan_WndWeddingDetails",WZUIContainer)
	conMan:removeAllChildrenWithCleanup(true)
	conGirl:removeAllChildrenWithCleanup(true)
	man:getAnimNode():setFlipX(true)
	conGirl:addChild(girl:getAnimNode())
	conMan:addChild(man:getAnimNode())

	local conTableDress = GetElement(self.m_root,"conTableDress_WndWeddingDetails",WZUITableContainer)
    conTableDress:cleanTable()
    local index = 0
    for k,v in pairs(weddingInfo.item_show) do
    	local temp = GDatatab_item["id_"..v[1]]
		if temp.sex ==  playerSex or temp == 2 then
			local eItem, tItem = CellGoodItem:createElement()
		    eItem:setScale(0.8)
		    eItem:setTag(index)
		    local time = v[2]
		    if time == -1 then
		    	time = 0
		    end
		    tItem:setItemClickFun(self, self.onClickDressItem)
		    local tData = {
			    id = v[1],
			    lastTime = time,
			    basicInfo = GetItemLocalData(v[1])
		    }
			tItem:setCellGoodItem(tData,4)
			conTableDress:setCellElement(eItem)
			index = index+1
    	end
    end
    self:updateFlipBtnStatus()

end

--@brief  点击服装item回调显示服装信息
function WndWeddingDetails:onClickDressItem(tItem, nTag, tData)
	WZLog("WndWeddingDetails:onClickDressItem")
	WndItemInfo:onCloseClick()
    local offset = GlobalMethod:ccp(0,0)
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,offset)
end

function WndWeddingDetails:onTouchBegan(element)
	WZLog("WndWeddingDetails:onTouchBegan")
	WndItemInfo:onCloseClick()
end

--@brief  设置翻页按钮状态
function WndWeddingDetails:updateFlipBtnStatus()
	WZLog("WndWeddingDetails:updateFlipBtnStatus = ",self.m_nCurShowWeddingType)
	local conLeft = GetElement(self.m_root,"conLeft_WndWeddingDetails",WZUIContainer)
	local conRight = GetElement(self.m_root,"conRight_WndWeddingDetails",WZUIContainer)
	if self.m_nCurShowWeddingType == 1 then
		conLeft:setVisible(false)
		conRight:setVisible(true)
	elseif self.m_nCurShowWeddingType == 2 then
		conLeft:setVisible(true)
		conRight:setVisible(true)
	elseif self.m_nCurShowWeddingType == 3 then
		conLeft:setVisible(true)
		conRight:setVisible(false)
	end
end

--@brief  查看下一页
function WndWeddingDetails:onClickNextPage(element)
	WZLog("WndWeddingDetails:onClickNextPage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurShowWeddingType = self.m_nCurShowWeddingType +1
	self:showWeddingInfo()
end

--@brief  查看前一页
function WndWeddingDetails:onClickFrontPage(element)
	WZLog("WndWeddingDetails:onClickFrontPage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurShowWeddingType = self.m_nCurShowWeddingType -1
	self:showWeddingInfo()
end

--@brief  点击了返回按钮
function WndWeddingDetails:onClickExit(element)
	WZLog("WndWeddingDetails:onClickExit")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndMarryBetrothed = WndMarryBetrothed:createElement()
    WZLog("WndWeddingDetails:onClickExit = ",self.m_nSeleWeddingType)
    WndMarryBetrothed:setWeddingType(self.m_nSeleWeddingType)
    WindowManager:addWindow(wndMarryBetrothed, WndMarryBetrothed,nil,nil,nil,false)
    WindowManager:removeWindow(self.m_root,WndWeddingDetails,true,false)
end

--@brief  举办婚礼
function WndWeddingDetails:onClickWedding(element)
	WZLog("WndWeddingDetails:onClickWedding")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local outFit = CacheCenter:getGameParam().wedMarryItem
    if outFit then
        local ids,items = SplitItemString(outFit)
        local monery = 0
        monery = items[self.m_nCurShowWeddingType]

        monery = tonumber(monery)
        if JudgeMarryDiscountExist() then --婚礼打折
            if self.m_nCurShowWeddingType == 1 then
                monery = math.ceil(monery * 0.5)
            elseif self.m_nCurShowWeddingType == 2 then
                monery = math.ceil(monery * 0.7)
            elseif self.m_nCurShowWeddingType == 3 then
                monery = math.ceil(monery * 0.9)
            end
        end
        if not JudgeMoneyIsEnough(tonumber(ids[self.m_nCurShowWeddingType]), monery, nil, nil, 96, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
    else
        local monery = 0
        if self.m_nWeddingType == 1 then
            monery = 2999
        elseif self.m_nWeddingType == 2 then
            monery = 1999
        elseif self.m_nWeddingType == 3 then
            monery = 999
        end
        if CacheCenter:getGameParam().isUseTicket == "0" then
        	if not JudgeMoneyIsEnough(70, monery, nil, nil, 96, nil, nil, nil, nil, self, self.clickSureMoney) then
            	return
        	end
        else
        	if not JudgeMoneyIsEnough(1, monery, nil, nil, 96, nil, nil, nil, nil, self, self.clickSureMoney) then
            	return
        	end
        end
    end
   
   self:clickSureMoney()
end

--@brief    点击确定充值回调
function WndWeddingDetails:clickSureMoney()
    local wndMarrySelectTime = WndMarryTimeSelect:createElement()
    WndMarryTimeSelect:setWeddingType(self.m_nCurShowWeddingType)
    WindowManager:addWindow(wndMarrySelectTime, WndMarryTimeSelect)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function WndWeddingDetails:_adaptLanguage_vn()
	GetElement(self.m_root,"txtWedding_WndWeddingDetails",WZUILabelTTF):setFontSize(21)
	GetElement(self.m_root,"txt1_WndWeddingDetails",WZUILabelTTF):setFontSize(21)
	GetElement(self.m_root,"txt2_WndWeddingDetails",WZUILabelTTF):setFontSize(22)

	local conPrice = GetElement(self.m_root,"conPrice_WndWeddingDetails",WZUIContainer)
	conPrice:setRelativePosition(GlobalMethod:ccp(0.6,0.0148815))
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
	txtWeddingType:setRelativePosition(GlobalMethod:ccp(0.16,0.475))

	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	txtDressInfo:setScale(0.65)
	txtDressInfo:setMaxWidth(500)
end

function WndWeddingDetails:_adaptLanguage_en()
	GetElement(self.m_root,"txtWedding_WndWeddingDetails",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txt1_WndWeddingDetails",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txt2_WndWeddingDetails",WZUILabelTTF):setFontSize(20)

	local conPrice = GetElement(self.m_root,"conPrice_WndWeddingDetails",WZUIContainer)
	conPrice:setRelativePosition(GlobalMethod:ccp(0.6,0.0148815))
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
	txtWeddingType:setRelativePosition(GlobalMethod:ccp(0.16,0.475))

	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	txtDressInfo:setScale(0.7)
	txtDressInfo:setMaxWidth(460)
end

function WndWeddingDetails:_adaptLanguage_pt()
	GetElement(self.m_root,"txtWedding_WndWeddingDetails",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt1_WndWeddingDetails",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txt2_WndWeddingDetails",WZUILabelTTF):setFontSize(20)

	local conPrice = GetElement(self.m_root,"conPrice_WndWeddingDetails",WZUIContainer)
	conPrice:setRelativePosition(GlobalMethod:ccp(0.6,0.0148815))
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
	txtWeddingType:setRelativePosition(GlobalMethod:ccp(0.16,0.475))

	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	txtDressInfo:setScale(0.66)
	txtDressInfo:setMaxWidth(490)
end

function WndWeddingDetails:_adaptLanguage_es(  )
	local txtWedding = GetElement(self.m_root,"txtWedding_WndWeddingDetails",WZUILabelTTF)
	txtWedding:setDimensions(GlobalMethod:CCSize(130,0))
	txtWedding:setFontSize(20)

	local conPrice = GetElement(self.m_root,"conPrice_WndWeddingDetails",WZUIContainer)
	conPrice:setRelativePosition(GlobalMethod:ccp(0.6,0.0148815))
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
	txtWeddingType:setRelativePosition(GlobalMethod:ccp(0.16,0.475))

	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	txtDressInfo:setScale(0.58)
	txtDressInfo:setMaxWidth(550)
end

function WndWeddingDetails:_adaptLanguage_th(  )
	local conPrice = GetElement(self.m_root,"conPrice_WndWeddingDetails",WZUIContainer)
	conPrice:setRelativePosition(GlobalMethod:ccp(0.6,0.0148815))
	local txtWeddingType = GetElement(self.m_root,"txtWeddingType_WndWeddingDetails",WZUILabelTTF)
	txtWeddingType:setRelativePosition(GlobalMethod:ccp(0.16,0.475))

	local txtDressInfo = GetElement(self.m_root,"txtDressInfo_WndWeddingDetails",WZUIFreeTextBox)
	txtDressInfo:setScale(0.7)
	txtDressInfo:setMaxWidth(460)
end
-------------------------------------语言适配模模块End----------------------------------------