--WndRecharge.lua
--@brief	WndRecharge的UI模块
--@date		2014/01/20
--@author	林庆凯
--@note		充值窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRecharge:onEnter(element)
	self.m_root = element
	WindowManagerAni:createAction(element,true)
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_TopUp)
	--注册充值相关协议
	ProtocolProcessorRecharge:regAll()
    self.m_nLoadingBoxId = MsgBoxManager:showLoadingBox()
    --ProtocolProcessorRecharge:send_PLAYER_GetPlayerInfo(0)
    --ProtocolProcessorRecharge:send_PURCHASE_GetRuleList()


    local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = curSdkObj.m_tConfig 
    if curSdkObj then
    	WZLog("WndRecharge:onEnter111",config.SDKOtherConfig.isNeedListToAppStore,#GlobalGame.g_tProducteList.productPrice)
    	if config.SDKOtherConfig.isNeedListToAppStore ~= "true"  or #GlobalGame.g_tProducteList.productPrice == 0 then
    		bIsLoadInIsland = false
    		WZLog("WndRecharge:onEnter111")
    	    ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(tonumber(PassportSdkManager:getChannelId()),1)
         else
         	WZLog("WndRecharge:onEnter111")
    	    self:getProductIdListFromAppStoreOk()
        end
    else
    	WZLog("WndRecharge:onEnter111")
        ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(tonumber(PassportSdkManager:getChannelId()),2)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRecharge:onExit(element)
	--反注册充值相关协议
	ProtocolProcessorRecharge:unregAll()
	self:_unInit()
end

--@brief	关闭窗口的函数
--@param	element:表绑定的UI节点引用
function WndRecharge:onCloseWindowBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndRecharge, true)
	end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end 

--@brief	提供给外部调用充值窗口的接口函数
--@param    nOrder,窗口层次
function WndRecharge:showRechargePage(nOrder)
	local wndRecharge = WndRecharge:createElement()
	if wndRecharge ~= nil then 
		if nOrder ~= nil then 
			wndRecharge:setZOrder(nOrder)
		end 
		WindowManager:addWindow(wndRecharge,WndRecharge)
	end 
end 

--@brief	点击单元格的充值按钮响应方法
--@param    nTag,单元格的tag
--@note     由CellRechargeList按钮响应方法回调回来
function WndRecharge:onClickRecharge(nTag)
	if self.m_root == nil then
		return
	end
    WZLog("WndRecharge:onClickRecharge", nTag,ProjConfig.CHANNEL_ID)
    if ProjConfig.CHANNEL_ID ~= 1210 then
        self.m_nLoadingBoxId = MsgBoxManager:showLoadingBox(50)
    end
    local tPayParams = {}
    tPayParams.productId = tostring(self.m_tProductList.ids[nTag])
    tPayParams.uid = GlobalGame.g_tPlayerInfo.nPlayerId
    tPayParams.amount = tostring(self.m_tProductList.pices[nTag])
    tPayParams.rate = "-1"
    tPayParams.description = ""
	--tPayParams.localizedTitle = tostring(self.m_tProductList.localizedTitle[nTag + 1])
	tPayParams.localizedTitle = tostring(self.m_tProductList.productPrice[nTag])
	if self.m_tProductList.localizedTitle then
		tPayParams.localizedTitle = tostring(self.m_tProductList.localizedTitle[nTag])
	end
    tPayParams.productIdentifier = tostring(self.m_tProductList.pices[nTag])
    tPayParams.playerName = GlobalGame.g_tPlayerInfo.sPlayerName

    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        tPayParams.userID = ""
        tPayParams.serverCode = ""
    else
        tPayParams.userID = data:getStringValue("AccountData", "account")
        tPayParams.serverCode = data:getStringValue("IPDParam", "ServerId")
    end
    tPayParams.playerName = GlobalGame.g_tPlayerInfo.sPlayerName
    tPayParams.playerLevel = GlobalGame.g_tPlayerInfo.nLevel
    tPayParams.productPrice = tostring(self.m_tProductList.productPrice[nTag])
    WZLog("WndRecharge:onClickRecharge:", self.m_tProductList.ids[nTag],json.encode(tPayParams))
    --local tCurSdkObj = PassportSdkManager:getCurSdkObj()
    --tCurSdkObj:doPay(json.encode(tPayParams), self.doPayCallBack, self)
    PassportSdkManager:doPay(json.encode(tPayParams), self.doPayCallBack, self)
end
--@brief	获取提示语成功
function WndRecharge:getTipSuccess(bShow)
	WZLog("GlobalGame.g_tSysConfig.openRecharge::::",GlobalGame.g_tSysConfig.openRecharge)
	if GlobalGame.g_tSysConfig.openRecharge == false then
		return
	end
	self.m_nCrit = bShow
	
end

--@brief	清空列表
function WndRecharge:create()
	if self.m_nIndex == nil or self.m_nIndex == 0 then
		return
	end
	local conRecharge = self.m_root:getChildElement("conRechargeIcon_WndRecharge")
	conRecharge = WZUIContainer:luaTo(conRecharge) 
	for i = 1 , self.m_nIndex do 
		conRecharge:removeChildByTag(i,true)
	end
	self.m_nIndex = 0
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新容器内充值列表的函数
function WndRecharge:_update()
	WZLog("maxCount::::::::::::::")
	if self.m_root == nil or self.m_tProductList == nil or self.m_tProductList.ids == nil then 
		WZLog(" WndRecharge:_update() self.m_root is nil")
		return 
	end 
	local maxCount = #self.m_tProductList.ids
	WZLog("maxCount::::::::::::::",maxCount)
	local conRecharge = self.m_root:getChildElement("conRechargeIcon_WndRecharge")
	conRecharge = WZUIContainer:luaTo(conRecharge)
	self:create()--清空列表
	local conSize = conRecharge:getContentSize()
	local itemSize = GlobalMethod:CCSize(0,0)
	WZLog("conSize:::::::",conSize.width,conSize.height)
	--充值显示六个选项，行数先固定为2行
	--local row = self:_checkRow(maxCount)
	local row = 2
	WZLog("充值列表行数:",maxCount,row)
	
	local x = 0
	local y = 1
	local nSpace = 46
	for var = 1 , 2 do 
		for i = 1 , 3 do 
			local celElement,tCell = CellRechargeList:createElement()
			conRecharge:addChild(celElement)
			itemSize = celElement:getContentSize()
			WZLog("itemSize:::::",itemSize.width,itemSize.height)
			celElement:setTag( (var-1)*3+i )
			celElement:setAnchorPoint(GlobalMethod:ccp(0,1))
			celElement:setRelativePosition(GlobalMethod:ccp(x,y))
			self.m_nIndex = self.m_nIndex + 1
			WZLog("x::::y:::",x,y,self.m_nIndex)
			x = x + (itemSize.width+nSpace)/conSize.width
            
             WZLog("sIconPath::::::::::",tostring(self.m_nIndex))
            local sIconPath = "ui/bottomMenu/pay/payment_"..tostring(self.m_nIndex)..".png"
            WZLog("sIconPath::::::::::",tostring(sIconPath))
            local nTickets = self:_getTicketsByIcon(self.m_tProductList.icons[var]) or 0
			local nDiscount = 0

			if self.m_tProductList.discount then
				nDiscount = self.m_tProductList.discount[(var-1)*3+i]
                WZLog("self.m_tProductList.discount",tostring(self.m_tProductList.productPrice[(var-1)*3+i]),sIconPath,nTickets,self.m_tProductList.discount[(var-1)*3+i])

                tCell:setProductInfo(self.m_tProductList.productPrice[(var-1)*3+i],sIconPath,self.m_tProductList.pices[(var-1)*3+i],tostring(self.m_tProductList.discount[(var-1)*3+i]))

			else
				 tCell:setProductInfo(self.m_tProductList.productPrice[(var-1)*3+i], sIconPath, nTickets,"0")
			end
		end
		y = y - itemSize.height/conSize.height
		x = 0
	end 
	self.m_oldSize = GlobalMethod:CCSize(0,0)
	local rechSize = self:_getRechSize()--获取充值容器的大小
	self.m_oldSize = rechSize
	WZLog("itemSize.height*row::::::",itemSize.height*row,conSize.height)
	if itemSize.height*row>conSize.height then
		self.m_nRech = itemSize.height*row-conSize.height
		local bLineH = itemSize.height*row/rechSize.height
		conRecharge:setAbsContentSize(GlobalMethod:CCSize(conSize.width,itemSize.height*row))
	
		self:_setRechSize(GlobalMethod:CCSize(rechSize.width,rechSize.height+itemSize.height*row-conSize.height))--设置充值容器的大小
		WZLog("self:_setRechSize====",rechSize.width,rechSize.height,rechSize.height+itemSize.height*row-conSize.height)
	end
	self:_showRechargeTip()--显示充值提示语
	self:setTotalDiamond()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
	
end 

--@brief	检查行的数量
function WndRecharge:_checkRow(maxCount)
	if maxCount == nil or maxCount == 0 then
		return 0
	end
	local count = 3
	if maxCount % count == 0 then
		return maxCount/count
	else
		return 1 + maxCount/count
	end
end

--@brief	设置总钻石数量的函数
function WndRecharge:setTotalDiamond()
	if self.m_root == nil then 
		WZLog(" WndRecharge:setTotalDiamond() self.m_root is nil")
		return 
	end 
	local txtDiamond = self.m_root:getChildElement("txtDiamond_WndRecharge")
	if txtDiamond ~= nil then 
		WZUILabelTTF:luaTo(txtDiamond):setText(tostring(CacheCenter:getPlayerInfo().blueDiamond))
	end 
end 

--@brief	显示充值提示语
function WndRecharge:_showRechargeTip()
	WZLog("GlobalGame.g_tSysConfig.openRecharge::::::",GlobalGame.g_tSysConfig.openRecharge)
	local bRech = GlobalGame.g_tSysConfig.openRecharge
	local theme = ""
	local tip = ""
	--bRech = true
	self:_showTip(bRech)--显示提示语
	self:_showTheme(bRech)--是否显示标题
	if bRech == true then
		theme = LocalStrings.RECHARGETIP--标题提示语
		tip = LocalStrings.RECHARGEDESC--设置提示语
	end
	self:_setTheme(theme)--标题提示语
	self:_setTip(tip)--设置提示语
	--@brief  	设置位置
	self:_setAllPostion()	--@brief  	更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
end

--@brief	显示提示语
function WndRecharge:_showTip(bShow)
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		txtTip:setVisible(bShow)
	end

end

--@brief	设置提示语
function WndRecharge:_setTip(txt)
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		txtTip:setText(txt)
	end
end

--@brief	获取提示语的大小
function WndRecharge:_getTipSize()
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		return txtTip:getAbsContentSize()
	end
end

--@brief	获取提示语的位置
function WndRecharge:_getTipPostion()
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		return txtTip:getRelativePosition()
	end
end

--@brief	设置提示语的位置
function WndRecharge:_setTipPostion(pt)
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		txtTip:setRelativePosition(pt)
	end
end

--@brief	获取提示语的大小
function WndRecharge:_getTipSize()
	local txtTip = self.m_root:getChildElement("txtTip_WndRecharge")
	if txtTip then 
		txtTip = WZUILabelTTF:luaTo(txtTip)
		return txtTip:getContentSize()
	end
end

--@brief	设置标题
function WndRecharge:_setTheme(theme)
	local txtTheme = self.m_root:getChildElement("txtTheme_WndRecharge")
	if txtTheme then
		txtTheme = WZUILabelTTF:luaTo(txtTheme)
		txtTheme:setText(theme)
	end
end

--@brief	是否显示标题
function WndRecharge:_showTheme(bShow)
	local txtTheme = self.m_root:getChildElement("txtTheme_WndRecharge")
	if txtTheme then
		txtTheme = WZUILabelTTF:luaTo(txtTheme)
		txtTheme:setVisible(bShow)
	end
end

--@brief	获取标题的位置
function WndRecharge:_getThemePostion()
	local txtTheme = self.m_root:getChildElement("txtTheme_WndRecharge")
	if txtTheme then
		txtTheme = WZUILabelTTF:luaTo(txtTheme)
		return txtTheme:getRelativePosition()
	end
end

--@brief	获取标题的大小
function WndRecharge:_getThemeSize()
	local txtTheme = self.m_root:getChildElement("txtTheme_WndRecharge")
	if txtTheme then
		txtTheme = WZUILabelTTF:luaTo(txtTheme)
		return txtTheme:getContentSize()
	end
end

--@brief	设置标题的位置
function WndRecharge:_setThemePostion(pt)
	local txtTheme = self.m_root:getChildElement("txtTheme_WndRecharge")
	if txtTheme then
		txtTheme = WZUILabelTTF:luaTo(txtTheme)
		txtTheme:setRelativePosition(pt)
	end
end

--@brief  	设置位置
function WndRecharge:_setAllPostion()
	local nSpace = 15
	local moveSize = self:_getMoveLyaerSize()--获取移动容器的大小
	local tipSize = self:_getTipSize()
	local rechSize = self:_getRechSize()
	local themePostion = self:_getThemePostion()--获取标题的位置
	local tipPostion = self:_getTipPostion()--获取提示语的位置
	local rechPostion = self:_getRechPostion()--获取充值容器的位置
	local bottomLine = self:_getBottomLinePos()--获取底部线条位置
    local themeHeight = ( tipSize.height*0.6 + rechSize.height -30)/moveSize.height
	--local themeHeight = ( tipSize.height  + rechSize.height)/moveSize.height
    local tipHeight =  ( rechSize.height - tipSize.height*0.3 - nSpace ) / moveSize.height
	--local tipHeight = ( rechSize.height + nSpace ) / moveSize.height
	local rechHeight = rechPostion.y
	local lineHeight = bottomLine.y
	if self.m_nRech then
		rechHeight = self.m_nRech/moveSize.height
		lineHeight = lineHeight - self.m_nRech/self.m_oldSize.height
	end
	WZLog("rechHeight::lineHeight::",rechHeight,lineHeight,self.m_oldSize.height)
	--设置标题的位置
	self:_setThemePostion(GlobalMethod:ccp(themePostion.x,themeHeight))
	--@brief	设置提示语的位置
	self:_setTipPostion(GlobalMethod:ccp(tipPostion.x,tipHeight))
	self:_setRechPostion(GlobalMethod:ccp(rechPostion.x,rechHeight))
	self:_setBottonLinePos(GlobalMethod:ccp(bottomLine.x,lineHeight))--设置底部线条位置
end

--@brief	获取移动容器的大小
function WndRecharge:_getMoveLyaerSize()
	local rollconExplanation = self.m_root:getChildElement("rollconExp_WndRecharge")
	if rollconExplanation ~= nil then 
		rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
		return rollconExplanation:getContentSize()
		--return rollconExplanation:getAbsContentSize()
	end
end

--@brief	获取充值容器的大小
function WndRecharge:_getRechSize()
	local conRech = self.m_root:getChildElement("conRech_WndRecharge")
	if conRech then
		conRech = WZUIContainer:luaTo(conRech)
		return conRech:getContentSize()
		--return conRech:getAbsContentSize()
	end
end

--@brief	设置充值容器的大小
function WndRecharge:_setRechSize(size)
	local conRech = self.m_root:getChildElement("conRech_WndRecharge")
	if conRech then
		conRech = WZUIContainer:luaTo(conRech)
		conRech:setAbsContentSize(size)
		WZLog("size:::::",size.width,size.height)
	end
end

--@brief	设置充值容器的位置
function WndRecharge:_setRechPostion(pt)
	local conRech = self.m_root:getChildElement("conRech_WndRecharge")
	if conRech then
		conRech = WZUIContainer:luaTo(conRech)
		conRech:setRelativePosition(pt)
	end
end

--@brief	获取充值容器的位置
function WndRecharge:_getRechPostion()
	local conRech = self.m_root:getChildElement("conRech_WndRecharge")
	if conRech then
		conRech = WZUIContainer:luaTo(conRech)
		return conRech:getRelativePosition()
	end
end

--@brief  	更新滚动容器内部布局函数
function WndRecharge:_upMoveContainerLayer()
	if self.m_root == nil then
		return
	end
	--获取说明文本大小
	local height = self:_getAllExpHeight()
	local rollconExplanation = self.m_root:getChildElement("rollconExp_WndRecharge")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getAbsContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	local bRech = GlobalGame.g_tSysConfig.openRecharge
	if bRech == true then
       -- moveElement:setRelativeSize( CCSize( size.width , (height+10) / rollSize.height ) )--hk
		moveElement:setRelativeSize( CCSize( size.width , (height) / rollSize.height ) )
        --moveElement:setRelativeSize( CCSize( size.width , (height-80) / rollSize.height ) )
	else
		moveElement:setRelativeSize( CCSize( size.width , (height-55) / rollSize.height ) )
	end
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end

--@brief	获取所以移动问题内容的高度
function WndRecharge:_getAllExpHeight()
	local themeSize = self:_getThemeSize()
	local tipSize = self:_getTipSize()
	local rechSize = self:_getRechSize()
	local nSpace = 30
	WZLog("themeSize::::::::::::::::::::::::::::",themeSize.width,themeSize.height)
	WZLog("tipSize::::::::::::::::::::::::::::",tipSize.width,tipSize.height)
	WZLog("rechSize::::::::::::::::::::::::::::",rechSize.width,rechSize.height)
	local height = themeSize.height + nSpace + tipSize.height + nSpace + 406 + 16
	WZLog("height::::::::::::::::::::::::::::",height)
	return height
end

--@brief	获取底部线条位置
function WndRecharge:_getBottomLinePos()
	local conBottomLine = self.m_root:getChildElement("conBottomLine_WndRecharge")
	if conBottomLine then
		conBottomLine = WZUIContainer:luaTo(conBottomLine)
        conBottomLine:setVisible(false)
		return conBottomLine:getRelativePosition()
	end
end

--@brief	设置底部线条位置
function WndRecharge:_setBottonLinePos(pt)
	local conBottomLine = self.m_root:getChildElement("conBottomLine_WndRecharge")
	if conBottomLine then
		conBottomLine = WZUIContainer:luaTo(conBottomLine)
		conBottomLine:setRelativePosition(pt)
	end
end

function WndRecharge:_showPayTip()
	if self.m_nCrit == nil then
		return
	elseif self.m_nCrit == true then
		WZLog("充值暴击提示语1：",LocalStrings.RECHARGESUCCESS)
		MsgBoxManager:showTipBox( LocalStrings.RECHARGESUCCESS )
	elseif self.m_nCrit == false then
		WZLog("充值暴击提示语2：",LocalStrings.RECHARGESUCCESS)
		MsgBoxManager:showTipBox( LocalStrings.RECHARGEFAIL )
	end
	self.m_nCrit = nil 
	self.m_root:disableSchedule()
	WZLog("暴击提示END:::::::")
end

-------------------------------------私有方法模块End----------------------------------------
