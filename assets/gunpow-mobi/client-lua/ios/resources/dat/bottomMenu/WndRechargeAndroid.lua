--WndRechargeAndroid.lua
--@brief	WndRechargeAndroid的UI模块
--@date		2014/04/27
--@author	liangguang_long
--@note		Android充值模块


local CHECKSIZE = GlobalMethod:CCSize(60,60)

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRechargeAndroid:onEnter(element)
	self.m_root = element
	self:_initData()
	self:getSimState()
	--self:setRechargeBtn()
    
    ProtocolProcessorRecharge:regAll()
    
    ProtocolProcessorRecharge:regAll()
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRechargeAndroid:onExit(element)
	self:_unInit()
end

--@brief	单击关闭按钮时被调用的函数
--@note		关闭后返回主界面
function WndRechargeAndroid:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--关闭邮件窗口
	WindowManager:removeWindow(self.m_root, WndRechargeAndroid, true)
end

--@brief	单击付费按钮回调函数
function WndRechargeAndroid:onPayClick(element)
	if self.m_bAviailable and self.m_nTag == 1 then --短信支付
		--ProtocolProcessorRecharge:send_PURCHASE_GetCallBackUri()
		--PassportSdkManager:doPayWithSDK()
		return
	end
	local payName = self:_getPayName()
	local payPwd = self:_getPayPwd()
	WZLog("payName:",payName)
	WZLog("payPwd:",self.m_nPar,payPwd)
	local tData = self:_getPayData(self.m_nTag)
	local parConut = tData[self.m_nPar+1].."元"--面值
	WZLog("parConut::",self.m_nTag,self.m_nPar,tData[self.m_nPar+1],parConut)

	--支付方式
	if self.m_bAviailable then
		if self.m_nTag > 2 then
			--其它付费方式
			if  self:checkName(payName) == false then
				MsgBoxManager:showTipBox("请输入正确账号!")
				return
			elseif self:checkPwd(payPwd) == false then
				MsgBoxManager:showTipBox("请输入正确密码!")
				return
			end
		end
	else
		if self.m_nTag > 1 then
			--其它付费方式
			if  self:checkName(payName) == false then
				MsgBoxManager:showTipBox("请输入正确账号!")
				return
			elseif self:checkPwd(payPwd) == false then
				MsgBoxManager:showTipBox("请输入正确密码!")
				return
			end
		end
	end
	
	--ProtocolProcessorRecharge:send_PURCHASE_GetCallBackUri()
end

--@brief	单击面值回调函数
function WndRechargeAndroid:onParFun(element,tag,desc)
	if self.m_root == nil or self.m_nPar == nil or self.m_nPar == tag then
		return
	end
	self.m_nPar = tag 
	self:_showParDesc(desc)--显示面值
	self:_setNorSelectCheck(tag)--设置没选择面值复选框的状态
end

--@brief	左按钮点击回调函数
function WndRechargeAndroid:onCheckClick(element,checkIndex,tag)
	if self.m_root == nil or self.m_tBtn == nil or self.m_nTag == tag then
		return
	end
	self.m_nTag = tag
	local tableLeftBtn = self.m_root:getChildElement("tableLeftBtn_WndRechargeAndroid")
	if tableLeftBtn == nil then
		return
	end
	tableLeftBtn = WZUITableContainer:luaTo(tableLeftBtn)
	WZLog("左按钮点击回调函数:",element,checkIndex,tag)
	for i,data in pairs(self.m_tBtn) do 
		if i-1 ~= tag then
			local tCell = tableLeftBtn:getCellElement(i-1)
			self:_setCellCheckIndex(tCell,0)
		end
	end

	local txtPay = self.m_root:getChildElement("txtPaypal2_WndRechargeAndroid")
	WZLog("短信支付",self.m_bAviailable,self.m_nTag)
	if txtPay then
		if self.m_bAviailable and self.m_nTag ==1 then
			WZLog("短信支付")
			txtPay = WZUILabelTTF:luaTo(txtPay)
			txtPay:setVisible(false)
		else
			txtPay = WZUILabelTTF:luaTo(txtPay)
			txtPay:setVisible(true)
		end
	end

	if self.m_bAviailable then
		--self.m_nTag = tag-1
		if tag==1 then
			--self:_gotoSMSPayment()
			local tCell = nil
        	--标题文本
        	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_TITLE_SMS)

        	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_CARD_SMS)
        	WZLog("左按钮点击回调函数1:",tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1_ZFB,tag)
        	tCell = nil
			
		elseif tag == 2 then
			local tCell = nil
        	--标题文本
        	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1_ZFB..":")
        	--选择的界面值文本
        	tCell = self.m_root:getChildElement("b")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE2)

        	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
        	self:_setTextDesc(tCell,"")
        	WZLog("左按钮点击回调函数2:",tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1_ZFB,tag)
        	tCell = nil
        else
        	local tCell = nil 
        	--标题文本
        	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1..":")
        	--选择的界面值文本
        	tCell = self.m_root:getChildElement("b")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE2)
        	--说明文本
        	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE3)
        	tCell = nil
		end
	else
		if tag==1 then
        	local tCell = nil
        	--标题文本
        	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1_ZFB..":")
        	--选择的界面值文本
        	tCell = self.m_root:getChildElement("b")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE2)

        	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
        	self:_setTextDesc(tCell,"")
        	WZLog("左按钮点击回调函数01:",tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1_ZFB,tag)
        	tCell = nil
    	else
        	local tCell = nil 
        	--标题文本
        	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1..":")
        	--选择的界面值文本
        	tCell = self.m_root:getChildElement("b")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE2)
        	--说明文本
        	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
        	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE3)
        	tCell = nil
    	end
	end
	self:_showSurface(tag)
	self:_setFrameIndex(self:_getFrameIndex(tag))--设置帧容器
	self:_upMoveLayer(tag)--更新滚动容器内部布局函数
	self:_initParByTag(tag)
	self:_initData()
end

--@brief   创建加载框
function WndRechargeAndroid:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(40)
end

--@brief   关闭加载框
function WndRechargeAndroid:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


--brief   获取SIM卡的状态
function WndRechargeAndroid:getSimState()
	local curSdkObj = PassportSdkManager:getCurSdkObj()
    local config = nil
    if curSdkObj then
        config = curSdkObj.m_tConfig   
		if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_ANDROID then
        	local adapter = WydPlAdapterManager:sharedWydPlAdapterManager():createAdapter("com/wyd/xingepush/WydXingeHelper")
        	WZLog("adapter:-------------------------",adapter)
       		local state = adapter:callMethodByNameReturn("getSmsState","")
        	if state == "true" and config.SDKOtherConfig.needSMSPayment == "true" then
        		self.m_bAviailable = true
        	else
        		self.m_bAviailable = false
        	end
            if adapter then
                WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(adapter:getId())
            end
    	end
    end

    if self.m_bAviailable then
    	self:setRechargeBtnWithSMS()
    else
    	self:setRechargeBtn()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function WndRechargeAndroid:_update()
	if self.m_root == nil or self.m_tBtn == nil then
		return
	end
	self:_showLeftBtn()--显示左边的按钮
	self:_initSurface()--初始化默认界面
	self:_showRightsurface()--显示右边的界面
	self:_upMoveLayer()--更新滚动容器内部布局函数
end

--@brief	显示界面
function WndRechargeAndroid:_showSurface(tag)
	if tag == 0 then
		self:_showRightsurfaceType1()--显示右边第一个类型的内容
	elseif tag >= 1 then
		self:_showRightsurfaceType2(tag)
	end
end

--@brief	显示左边的按钮
function WndRechargeAndroid:_showLeftBtn()
	local tableLeftBtn = self.m_root:getChildElement("tableLeftBtn_WndRechargeAndroid")
	if tableLeftBtn == nil then
		return
	end
	tableLeftBtn = WZUITableContainer:luaTo(tableLeftBtn)
	tableLeftBtn:cleanTable()--清空列表
	for i,data in pairs(self.m_tBtn) do 
		local celElement , tCell = CellRechargeAndroid:createElement()
		celElement:setTag(i-1)
		tableLeftBtn:setCellElement(celElement)
		tCell:setCellData(data)
		tCell:setBackFun(self,self.onCheckClick)
	end
end

--@brief	显示右边
function WndRechargeAndroid:_showRightsurface()
	self:_showRightsurfaceType1()--显示右边第一个类型的内容
end

--@brief	显示右边第一个类型的内容
function WndRechargeAndroid:_showRightsurfaceType1()
	self:_setTypeOneDesc()--右边第一个类型的内容
	self:_setTypeOnePt()--右边第一个类型文本的位置
end

--@brief	右边第一个类型的内容
function WndRechargeAndroid:_setTypeOneDesc()
	local tCell = nil 
	--标题文本
	tCell = self.m_root:getChildElement("txtDesc1_WndRechargeAndroid")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_TITLE..":")
	--说明文本
	tCell = self.m_root:getChildElement("txtDesc2_WndRechargeAndroid")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_CARD)
	--提示语文本
	tCell = self.m_root:getChildElement("txtDesc3_WndRechargeAndroid")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PROMPT)
	tCell = nil 
end

--@brief	右边第一个类型文本的位置
function WndRechargeAndroid:_setTypeOnePt()
	local tCell1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc1_WndRechargeAndroid"))--标题文字
	local tCell2 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc2_WndRechargeAndroid"))--文本内容
	local tCell3 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDesc3_WndRechargeAndroid"))--提示语文本
	self:_setTextPt(tCell1,tCell2)--设置文本内容的位置
	self:_setTextPt(tCell2,tCell3,-20)--设置提示语文本的位置
end

--@brief	设置帧容器的索引
function WndRechargeAndroid:_setFrameIndex(index)
	local frameRight = self.m_root:getChildElement("frameRight_WndRechargeAndroid")
	if frameRight then
		frameRight = WZUIFrameElement:luaTo(frameRight)
		frameRight:ShowFrameElement(index)
	end
end

--@brief	获取帧容器的位置
function WndRechargeAndroid:_getFrame()
	local frameRight = self.m_root:getChildElement("frameRight_WndRechargeAndroid")
	if frameRight then
		frameRight = WZUIFrameElement:luaTo(frameRight)
		return frameRight:getRelativePosition(),frameRight:getContentSize()
	end
end

--@brief	设置帧容器的位置
function WndRechargeAndroid:_setFramePt(pt)
	local frameRight = self.m_root:getChildElement("frameRight_WndRechargeAndroid")
	if frameRight then
		frameRight = WZUIFrameElement:luaTo(frameRight)
		frameRight:setRelativePosition(pt)
	end
end

--@brief	显示右边第二个类型的内容
function WndRechargeAndroid:_showRightsurfaceType2(tag)
	--self:_setTypeTwoDesc()--右边第二个类型的内容
	self:_setTypeTwoPt()
	self:_setPar(tag)
	self:_setTypeTwoPtA()
	self:_setTypeTwoPtB(tag)
end

--@brief	右边第二个类型的内容
function WndRechargeAndroid:_setTypeTwoDesc()
	local tCell = nil 
	--标题文本
	tCell = self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE1..":")
	--选择的界面值文本
	tCell = self.m_root:getChildElement("b")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE2)
	
	--说明文本
	tCell = self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid")
	self:_setTextDesc(tCell,GlobalGame.PayCard.RECHARGE_PAYTITLE3)
	tCell = nil 
end

--@brief	设置购买面值
function WndRechargeAndroid:_setPar(tag)
	local maxCount = self:_getParProperty(tag)
	local var = 3
	local row = 0
	local x = 0.48
	local y = 0.75
	local xx = 0.35
	local yy = 0.22
	local index = 1
	row = math.ceil(maxCount/3)
	local size = GlobalMethod:CCSize(420,row*CHECKSIZE.height)
	WZLog("row:col:",row,size.width,size.height)
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	if conPar == nil then
		return
	end
	conPar = WZUIContainer:luaTo(conPar)
	self:removeAllMoveChild(conPar)
	for i=1,row do
		local num = self:_getVar(i,var,maxCount)
		for i=1, num do
			local cellElement,tCell = CellRechargePar:createElement()
			cellElement:setTag(self.m_nIndex)
			cellElement:setRelativePosition(GlobalMethod:ccp(x,y))
			tCell:setAllData(self:_getPayData(tag)[index])
			tCell:setBackFun(self,self.onParFun)
			conPar:addChild(cellElement)
			self.m_nIndex = self.m_nIndex + 1
			x = x + xx
			index = index + 1
		end
		x = 0.48
		y = y - yy
	end
	self:_setParValueSize(size)
end

--@brief	设置选择冲值卡容器大小
function WndRechargeAndroid:_setParValueSize(size)
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	if conPar then
		conPar = WZUIContainer:luaTo(conPar)
		conPar:setAbsContentSize(size)
	end
end

--@brief	设置选择冲值卡容器大小
function WndRechargeAndroid:_getParValueSize()
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	if conPar then
		conPar = WZUIContainer:luaTo(conPar)
		return conPar:getAbsContentSize()
	end
end

--@brief	设置选择冲值卡容器位置
function WndRechargeAndroid:_getParValuePt()
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	if conPar then
		conPar = WZUIContainer:luaTo(conPar)
		return conPar:getRelativePosition()
	end
end

--@brief	右边第二个类型文本的位置
function WndRechargeAndroid:_setTypeTwoPt()
	local tCell1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid"))--标题文字
	local tCell2 = WZUIContainer:luaTo(self.m_root:getChildElement("conPar_WndRechargeAndroid"))--文本内容
	self:_setTextPt(tCell1,tCell2)--设置文本内容的位置
end

--@brief	右边第二个类型文本的位置A
function WndRechargeAndroid:_setTypeTwoPtA()
	local dir = -10
	local parSize = self:_getParValueSize()--冲值卡容器大小
	local parPt = self:_getParValuePt()--冲值卡容器位置
	local tCell2 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal2_WndRechargeAndroid"))
	local lpSize = tCell2:getParentElement():getContentSize()
	local x = parPt.x 
	local y = parPt.y - (parSize.height+dir)/lpSize.height
	tCell2:setRelativePosition(GlobalMethod:ccp(x,y))
	local tCell3 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid"))
	self:_setTextPt(tCell2,tCell3)--设置文本内容的位置
end

--@brief	右边第二个类型文本的位置B
function WndRechargeAndroid:_setTypeTwoPtB(tag)
	local parConut,bPay,btnText = self:_getParProperty(tag)
	if bPay == true then
		local tCell1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid"))
		local tCell2 = WZUIContainer:luaTo(self.m_root:getChildElement("conName_WndRechargeAndroid"))
		self:_setPayPt(tCell1,tCell2)
		--设置文本内容的位置
		local tCell3 = WZUIContainer:luaTo(self.m_root:getChildElement("conName_WndRechargeAndroid"))
		local tCell4 = WZUIContainer:luaTo(self.m_root:getChildElement("conPwd_WndRechargeAndroid"))
		self:_setPayPt(tCell3,tCell4)
		--设置文本内容的位置
		local tCell5 = WZUIContainer:luaTo(self.m_root:getChildElement("conPwd_WndRechargeAndroid"))
		local tCell6 = WZUIButton:luaTo(self.m_root:getChildElement("btnPay_WndRechargeAndroid"))
		self:_setPayPt(tCell5,tCell6)
		tCell3:setVisible(true)
		tCell4:setVisible(true)
	else
		local tCell1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid"))
		local tCell2 = WZUIButton:luaTo(self.m_root:getChildElement("btnPay_WndRechargeAndroid"))
		self:_setPayPt(tCell1,tCell2)
	end
	self:_setPayNameVisible(bPay)--显示账号
	self:_setPayPwdVisible(bPay)--密码
	self:_setPayDesc(btnText)
	self:_setPayVisible(true)
end

--@brief	初始化默认选择第一个面值
function WndRechargeAndroid:_initPay(tag)
	tag = tag or 0
	local tableLeftBtn = self.m_root:getChildElement("tableLeftBtn_WndRechargeAndroid")
	if tableLeftBtn then
		tableLeftBtn = WZUITableContainer:luaTo(tableLeftBtn)
		local tCell = tableLeftBtn:getCellElement(tag)
		self:_setCellCheckIndex(tCell,1)
	end
end

--@brief	设置按钮文本
function WndRechargeAndroid:_setPayDesc(txt)
	local txtPay = self.m_root:getChildElement("txtPay_WndRechargeAndroid")
	if txtPay then
		txtPay = WZUILabelTTF:luaTo(txtPay)
		txtPay:setText(txt)
	end
end

--@brief	设置按钮文本
function WndRechargeAndroid:_setPayVisible(bShow)
	local txtPay = self.m_root:getChildElement("txtPay_WndRechargeAndroid")
	if txtPay then
		txtPay = WZUILabelTTF:luaTo(txtPay)
		txtPay:setVisible(bShow)
	end
end

--@brief	显示支付账号
function WndRechargeAndroid:_setPayNameVisible(bShow)
	local conName = self.m_root:getChildElement("conName_WndRechargeAndroid")
	if conName then
		conName = WZUIContainer:luaTo(conName)
		conName:setVisible(bShow)
	end
end

--@brief	显示支付密码
function WndRechargeAndroid:_setPayPwdVisible(bShow)
	local conPwd = self.m_root:getChildElement("conPwd_WndRechargeAndroid")
	if conPwd then
		conPwd = WZUIContainer:luaTo(conPwd)
		conPwd:setVisible(bShow)
	end
end

--@brief	获取充值类型高度
function WndRechargeAndroid:_getAllSize(tag)
	local h = 0
	local dir = 8
	local space = 0 
	local parConut,bPay,btnText = self:_getParProperty(tag)
	if tag == 0 then
		return self:_getDescHeight() 
	end
	--标题
	local txt1 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal1_WndRechargeAndroid"))
	local txtSize1 = txt1:getContentSize()
	--冲值面值
	local txt2 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal2_WndRechargeAndroid"))
	local txtSize2 = txt2:getContentSize()
	--说明文本
	local txt3 = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtPaypal3_WndRechargeAndroid"))
	local txtSize3 = txt3:getContentSize()
	--账号
	local conName = WZUIContainer:luaTo(self.m_root:getChildElement("conName_WndRechargeAndroid"))
	local nameSize = conName:getContentSize()
	--密码
	local conPwd = WZUIContainer:luaTo(self.m_root:getChildElement("conPwd_WndRechargeAndroid"))
	local pwdSize = conPwd:getContentSize()
	--支付按钮
	local btnPay = WZUIButton:luaTo(self.m_root:getChildElement("btnPay_WndRechargeAndroid"))
	local paySize = btnPay:getContentSize()
	local conSize = self:_getParValueSize()--设置选择冲值卡容器大小
	if bPay == true then
		space = dir * 7
		h = h + txtSize1.height + txtSize2.height + txtSize3.height + nameSize.height 
		h = h + pwdSize.height + paySize.height + conSize.height + space
	else
		space = dir * 5
		h = h + txtSize1.height + txtSize2.height + txtSize3.height + paySize.height + conSize.height + space
	end
	return h
end

--@brief	获取充值说明高度
function WndRechargeAndroid:_getDescHeight()
	local h = 0 
	for i=1,3 do 
		local sName = "txtDesc%d_WndRechargeAndroid"
		sName = string.format(sName,i)
		local txtDesc = self.m_root:getChildElement(sName)
		if txtDesc then
			txtDesc = WZUILabelTTF:luaTo(txtDesc)
			h = h + txtDesc:getContentSize().height
		end
	end
	return h
end

--@brief  	更新滚动容器内部布局函数
function WndRechargeAndroid:_upMoveLayer(tag)
	tag = tag or 0
	local rollcon = self.m_root:getChildElement("rollcon_WndRechargeAndroid")
	if rollcon == nil then 
		return
	end
	rollcon = WZUIMoveContainer:luaTo(rollcon)
	local h = self:_getAllSize(tag)
	local rollSize = rollcon:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollcon:getMoveElement()
	moveElement:setContentSize(GlobalMethod:CCSize(rollSize.width,h))
	rollcon:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollcon:getMinPosition().y)
	local framePt,frameSize = self:_getFrame()
	local x = framePt.x
	local y = (h - rollSize.height - self:_getSpaceByTag(tag))/rollSize.height
	self:_setFramePt(GlobalMethod:ccp(x,y))
end

--@brief  	获取更新滚动容器大小
function WndRechargeAndroid:_getMoveSize()
	local rollcon = self.m_root:getChildElement("rollcon_WndRechargeAndroid")
	rollcon = WZUIMoveContainer:luaTo(rollcon)
	self.m_moveSize = rollcon:getContentSize()
end

--@brief  	设置账号
function WndRechargeAndroid:_setPayName(payName)
	payName = payName or ""
	local editName = self.m_root:getChildElement("editName_WndRechargeAndroid")
	if editName then
		editName = WZUIEditBox:luaTo(editName)
		editName:setText(payName)
	end
end

--@brief  	获取账号
function WndRechargeAndroid:_getPayName()
	local editName = self.m_root:getChildElement("editName_WndRechargeAndroid")
	if editName then
		editName = WZUIEditBox:luaTo(editName)
		return editName:getText()
	end
end

--@brief  	设置密码
function WndRechargeAndroid:_setPayPwd(payPwd)
	payPwd = payPwd or ""
	local editPwd = self.m_root:getChildElement("editPwd_WndRechargeAndroid")
	if editPwd then
		editPwd = WZUIEditBox:luaTo(editPwd)
		editPwd:setText(payPwd)
	end
end

--@brief  	获取密码
function WndRechargeAndroid:_getPayPwd()
	local editPwd = self.m_root:getChildElement("editPwd_WndRechargeAndroid")
	if editPwd then
		editPwd = WZUIEditBox:luaTo(editPwd)
		return editPwd:getText()
	end
end

--@brief  	显示面值
function WndRechargeAndroid:_showParDesc(desc)
	if desc == nil or desc == "" then
		return 
	end
	WZLog("desc1:",desc)
	desc = desc:gsub("元","")
	WZLog("desc2:",desc)
	local x = self:_getMoney2Diamond(tonumber(desc))
	local txt = string.format(GlobalGame.PayCard.RECHARGE_PAYTITLE2,tonumber(desc),x*10)

	self:_setParDesc(txt)
	
end

--@brief  	设置面值
function WndRechargeAndroid:_setParDesc(desc)
	local txtPay = self.m_root:getChildElement("txtPaypal2_WndRechargeAndroid")
	WZLog("短信支付",self.m_bAviailable,self.m_nTag)
	if txtPay then
		if self.m_bAviailable and self.m_nTag ==1 then
			WZLog("短信支付")
			txtPay = WZUILabelTTF:luaTo(txtPay)
			txtPay:setText("")
			txtPay:setVisible(false)
		else
			txtPay = WZUILabelTTF:luaTo(txtPay)
			txtPay:setText(desc)
			txtPay:setVisible(true)
		end
		
	end
end

--@brief  	设置没选择面值复选框的状态
function WndRechargeAndroid:_setNorSelectCheck(tag)
	if self.m_root == nil or self.m_nTag == nil or self.m_nTag == 0 then
		return
	end
	local tData = self:_getPayData(self.m_nTag)
	for i , data in pairs(tData) do 
		local tCell = self:_getParElementByTag(i-1)--
		WZLog("tCell:::",i,tag,tCell,self.m_nTag,data)
		if tCell and tag ~= i-1 then
			tCell:setCheckIndex(0)
		end
	end
end

--@brief  	获取面值复选框的节点
function WndRechargeAndroid:_getParElementByTag(tag)
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	conPar = WZUIContainer:luaTo(conPar)
	local tCell = conPar:getChildByTag(tag)
	if tCell then
		local tCellChild = tCell:getChildElement("checkPar_CellRechargePar")
		if tCellChild then
			tCellChild = WZUICheckBox:luaTo(tCellChild)
			return tCellChild
		end
	end
end

--@brief  	获取面值
function WndRechargeAndroid:_getParDescByTag(tag)
	local conPar = self.m_root:getChildElement("conPar_WndRechargeAndroid")
	conPar = WZUIContainer:luaTo(conPar)
	local tCell = conPar:getChildByTag(tag)
	if tCell then
		local tCellChild = tCell:getChildElement("txtPar_CellRechargePar")
		if tCellChild then
			tCellChild = WZUILabelTTF:luaTo(tCellChild)
			return tCellChild:getText()
		end
	end
end

--@brief  	初始化面值
function WndRechargeAndroid:_initParByTag(tag)
	if self.m_root == nil or tag == nil or tag == 0 then
		return
	end
	--选择面值
	local tCell = self:_getParElementByTag(0)
	if tCell then
		tCell:setCheckIndex(1)
	end
	local desc = self:_getParDescByTag(0)--面值
	self:_showParDesc(desc)--显示面值
end

--@brief  	付费按钮是否可点击
function WndRechargeAndroid:_setPayBtnTouch(bTouch)
	local btnPay = self.m_root:getChildElement("btnPay_WndRechargeAndroid")
	if btnPay then
		btnPay = WZUIButton:luaTo(btnPay)
		btnPay:setTouchEnable(bTouch)
	end
end


-------------------------------------私有方法模块End----------------------------------------






